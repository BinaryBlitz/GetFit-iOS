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
  
  fileprivate(set) var selectedCategory: TrainerCategory = .Coach
  let categories: [TrainerCategory] = [.Coach, .Doctor, .Nutritionist]
  
  let trainersProvider = APIProvider<GetFit.Trainers>()
  
  var coaches = [Trainer]()
  var doctors = [Trainer]()
  var nutritionists = [Trainer]()
  
  var refreshControl: UIRefreshControl?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    setupTableView()
    
    refresh()
  }
  
  fileprivate func setupTableView() {
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.registerReusableCell(ProfessionalTableViewCell)
    tableView.rowHeight = 370
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    tableView.backgroundView = EmptyStateHelper.backgroundViewFor(.trainers)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }
  
  func reloadTableViewWith(_ category: TrainerCategory) {
    selectedCategory = category
  }
  
  //MARK: - Refresh
  
  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? ProfessionalTableViewController,
        let trainer = sender as? Trainer, segue.identifier == "professionalInfo" {
      destination.trainer = trainer
    }
  }
  
  fileprivate func trainerAtIndexPath(_ indexPath: IndexPath) -> Trainer? {
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows: Int
    switch selectedCategory {
    case .Coach:
      numberOfRows = coaches.count
    case .Nutritionist:
      numberOfRows = nutritionists.count
    case .Doctor:
      numberOfRows = doctors.count
    }
    
    tableView.backgroundView?.isHidden = numberOfRows != 0
    return numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let trainer = trainerAtIndexPath(indexPath) else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProfessionalTableViewCell
    cell.configureWith(trainer)
    cell.state = .Card
    cell.delegate = self
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let labels = categories.map { $0.pluralName() }
    let buttonStrip = ButtonsStripView(labels: labels)
    buttonStrip.delegate = self
    buttonStrip.selectedIndex = categories.index(of: selectedCategory) ?? 0
    
    return buttonStrip
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}


extension ProfessionalsViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let trainer = trainerAtIndexPath(indexPath) else {
      return
    }
    performSegue(withIdentifier: "professionalInfo", sender: trainer)
  }
}

extension ProfessionalsViewController: ButtonStripViewDelegate {
  
  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedCategory = categories[index]
    refresh()
    tableView.contentOffset = CGPoint.zero
    tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.bottom)
  }
}

extension ProfessionalsViewController: ProfessionalCellDelegate {
  func professionalCell(_ cell: ProfessionalTableViewCell, didChangeFollowingTo: Bool) {
    guard let indexPath = tableView.indexPath(for: cell), let trainer = trainerAtIndexPath(indexPath) else {
      return
    }
    
    print("trainer: \(trainer.firstName)")
  }
}
