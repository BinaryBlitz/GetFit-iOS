//
//  ProgramDetailsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
import Reusable

class ProgramDetailsTableViewController: UITableViewController {
  
  var program: Program!
  var workouts: Results<Workout>?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    tableView.registerReusableCell(ProgramTableViewCell)
    
    let headerNib = UINib(nibName: String(WorkoutHeaderView), bundle: nil)
    tableView.registerNib(headerNib, forHeaderFooterViewReuseIdentifier: String(WorkoutHeaderView))
    
    let realm = try! Realm()
    workouts = realm.objects(Workout).filter("programId == \(program.id)").sorted("position")
    
    updateProgramInfo()
  }
  
  func updateProgramInfo() {
    ServerManager.sharedManager.showProgramWithId(program.id) { (response) in
      switch response.result {
      case .Success(let program):
        self.program = program
        self.tableView.reloadData()
      case .Failure(let error):
        self.presentAlertWithMessage("error: \(error)")
      }
    }
  }
  
  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1 + (workouts?.count ?? 0)
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let workouts = workouts else { return 1 }
    
    if section == 0 {
      return 1
    } else {
      let exercisesCount = workouts[section - 1].exercises.count
      if exercisesCount <= 2 {
        return exercisesCount
      }
      
      return 3
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProgramTableViewCell
      cell.configureWith(ProgramViewModel(program: program))
      cell.state = .Normal
      cell.delegate = self
      
      return cell
    } else {
      guard let exercises = workouts?[indexPath.section - 1].exercises else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell")!
        
      if indexPath.row < 2 {
        cell.textLabel?.text = exercises[indexPath.row].name
      } else {
        cell.textLabel?.textColor = UIColor.blueAccentColor()
        cell.textLabel?.text = "+\(exercises.count - 2) more exercises".uppercaseString
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(13)
      }
      
      return cell
    }
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0.01
    }
    
    return 40
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 9
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 400
    default:
      return 55
    }
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let workouts = workouts where section != 0 && workouts.count > 0 else { return nil }
    let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(WorkoutHeaderView)) as! WorkoutHeaderView
    let workout = workouts[section - 1]
    headerView.configureWith(workout)
    
    return headerView
  }
}

extension ProgramDetailsTableViewController: ProgramCellDelegate {
  func didTouchBuyButtonInCell(cell: ProgramTableViewCell) {
    self.presentAlertWithMessage("gimme da progam b0ss")
  }
}