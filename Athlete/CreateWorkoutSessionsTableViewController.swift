//
//  CreateWorkoutSessionsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
import Reusable

class CreateWorkoutSessionsTableViewController: UITableViewController {
  
  var workouts = [Workout]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "choose training".uppercaseString
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self,
                                                       action: #selector(self.closeButtonAction(_:)))
    
    tableView.registerReusableCell(TrainingTableViewCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
    
    let realm = try! Realm()
    workouts = Array(realm.objects(Workout).sorted("duration"))
    loadWorkouts()
  }
  
  func loadWorkouts() {
    ServerManager.sharedManager.fetchWorkouts { (response) in
      switch response.result {
      case .Success(let workouts):
        self.workouts = workouts
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        let realm = try! Realm()
        try! realm.write {
          realm.add(workouts, update: true)
        }
      case .Failure(let error):
        self.presentAlertWithMessage("Error: \(error)")
      }
    }
  }
  
  //MARK: - Actions
  
  func closeButtonAction(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workouts.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TrainingTableViewCell
    let workout = workouts[indexPath.row]
    cell.configureWith(workout)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return nil
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
