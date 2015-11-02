//
//  TrainingProgramTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class TrainingProgramTableViewController: UITableViewController {
  
  var training: (String, Double)!
  var exercises = ["Push Ups", "Turns", "Body Blast", "Power Ups"]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: Transparent navigationBar
//    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//    navigationController?.navigationBar.shadowImage = UIImage()
//    navigationController?.navigationBar.translucent = true
//    navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
  }
  
  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 1 : 3
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCellWithIdentifier("titleCell") else {
        return UITableViewCell()
      }
      
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        imageView.image = UIImage(named: training.0)
      }
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell") else {
        return UITableViewCell()
      }
      
      if indexPath.row < 2 {
        cell.textLabel?.text = exercises[indexPath.row]
      } else {
        cell.textLabel?.textColor = UIColor.blueAccentColor()
        cell.textLabel?.text = "+2 more exercises".uppercaseString
        cell.textLabel?.font = UIFont.boldSystemFontOfSize(13)
      }
      
      return cell
    }
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0.01
    }
    
    return 10
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 {
      let width = tableView.frame.width
      return width / CGFloat(training.1)
    } else {
      return 50
    }
  }
}
