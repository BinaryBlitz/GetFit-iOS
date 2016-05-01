//
//  ProfessionalsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
//import XLPagerTabStrip

class ProfessionalsViewController: UIViewController {
  
//  var stripView: ButtonsStripView
  
  @IBOutlet weak var tableView: UITableView!
  
  private(set) var selectedCategory: TrainerCategory = .Coach
  let categories: [TrainerCategory] = [.Coach, .Doctor, .Nutritionist]
  
  var coaches: Results<Trainer>?
  var doctors: Results<Trainer>?
  var nutritionists: Results<Trainer>?
  
  var refreshControl: UIRefreshControl?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    setupTableView()
    
    let realm = try! Realm()
    
    //TODO: sort by popularity
    coaches = realm.objects(Trainer).filter("categoryValue = '\(TrainerCategory.Coach.rawValue)'").sorted("id")
    doctors = realm.objects(Trainer).filter("categoryValue = '\(TrainerCategory.Doctor.rawValue)'").sorted("id")
    nutritionists = realm.objects(Trainer).filter("categoryValue = '\(TrainerCategory.Nutritionist.rawValue)'").sorted("id")
  }
  
  private func setupTableView() {
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
    let trainerCellNib = UINib(nibName: String(ProfessionalTableViewCell), bundle: nil)
    tableView.registerNib(trainerCellNib, forCellReuseIdentifier: String(ProfessionalTableViewCell))
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
    delayFor(2) {
      completion()
    }
  }
  
  func delayFor(delay: Double, closure: () -> Void) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
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
      if let coach = coaches?[indexPath.row] {
        trainer = coach
      }
    case .Doctor:
      if let doctor = doctors?[indexPath.row] {
        trainer = doctor
      }
    case .Nutritionist:
      if let nutritionist = nutritionists?[indexPath.row] {
        trainer = nutritionist
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
      return coaches?.count ?? 0
    case .Nutritionist:
      return nutritionists?.count ?? 0
    case .Doctor:
      return doctors?.count ?? 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = String(ProfessionalTableViewCell)
    guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ProfessionalTableViewCell,
              trainer = trainerAtIndexPath(indexPath) else {
      return UITableViewCell()
    }
    
    cell.configureWith(trainer)
    cell.state = .Card
    
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
    tableView.contentOffset = CGPoint.zero
    tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Bottom)
  }
}
