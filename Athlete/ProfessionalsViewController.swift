//
//  ProfessionalsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift

class ProfessionalsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private(set) var selectedCategory: TrainerCategory = .Coach
  let categories: [TrainerCategory] = [.Coach, .Doctor, .Nutritionist]
  
  let trainersProvider = APIProvider<GetFit.Trainers>()
  
  var coaches = [Trainer]()
  var doctors = [Trainer]()
  var nutritionists = [Trainer]()
  
  var refreshControl: UIRefreshControl?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    setupTableView()
    
    refresh()
  }
  
  private func setupTableView() {
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.registerReusableCell(ProfessionalTableViewCell)
    tableView.rowHeight = 370
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  func reloadTableViewWith(category: TrainerCategory) {
    selectedCategory = category
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    trainersProvider.request(.Index(filter: TrainersFilter(category: selectedCategory))) { (result) in
      completion()
      switch result {
      case .Success(let response):
        
        do {
          let trainersResponse = try response.filterSuccessfulStatusCodes()
          let trainers = try trainersResponse.mapArray(Trainer.self)
          
          let realm = try Realm()
          try realm.write {
            realm.add(trainers, update: true)
          }
          
          if let trainer = trainers.first {
            switch trainer.category {
            case .Coach:
              self.coaches = trainers
            case .Doctor:
              self.doctors = trainers
            case .Nutritionist:
              self.nutritionists = trainers
            }
          }
        
          self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
        } catch {
          print("Cannot fetch trainers")
        }
        
      case .Failure(let error):
        print(error)
      }
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? ProfessionalTableViewController,
        trainer = sender as? Trainer
        where segue.identifier == "professionalInfo" {
      destination.trainer = trainer
    }
  }
  
  private func trainerAtIndexPath(indexPath: NSIndexPath) -> Trainer? {
    var trainer: Trainer? = nil
    
    switch selectedCategory {
    case .Coach:
      if indexPath.row < coaches.count {
        trainer = coaches[indexPath.row]
      }
    case .Doctor:
      if indexPath.row < doctors.count {
        trainer = doctors[indexPath.row]
      }
    case .Nutritionist:
      if indexPath.row < nutritionists.count {
        trainer = nutritionists[indexPath.row]
      }
    }
    
    return trainer
  }
}

//MARK: - UITableViewDataSource

extension ProfessionalsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch selectedCategory {
    case .Coach:
      return coaches.count
    case .Nutritionist:
      return nutritionists.count
    case .Doctor:
      return doctors.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let trainer = trainerAtIndexPath(indexPath) else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProfessionalTableViewCell
    cell.configureWith(trainer)
    cell.state = .Card
    cell.delegate = self
    
    return cell
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let labels = categories.map { $0.pluralName() }
    let buttonStrip = ButtonsStripView(labels: labels)
    buttonStrip.delegate = self
    buttonStrip.selectedIndex = categories.indexOf(selectedCategory) ?? 0
    
    return buttonStrip
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}


extension ProfessionalsViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let trainer = trainerAtIndexPath(indexPath) else {
      return
    }
    performSegueWithIdentifier("professionalInfo", sender: trainer)
  }
}

extension ProfessionalsViewController: ButtonStripViewDelegate {
  
  func stripView(view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedCategory = categories[index]
    refresh()
    tableView.contentOffset = CGPoint.zero
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
  }
}

extension ProfessionalsViewController: ProfessionalCellDelegate {
  func professionalCell(cell: ProfessionalTableViewCell, didChangeFollowingTo: Bool) {
    guard let indexPath = tableView.indexPathForCell(cell), trainer = trainerAtIndexPath(indexPath) else {
      return
    }
    
    print("trainer: \(trainer.firstName)")
  }
}
