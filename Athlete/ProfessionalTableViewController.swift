//
//  ProfessionalTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 02/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProfessionalTableViewController: UITableViewController {

  var trainer: (String, Double)!
  let stuff = [("GetTraining", 8.55), ("TabsView", 8.506)]
  let trainings = [("training1", 1.01), ("training3", 1.09)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.separatorStyle = .None
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 3
    } else {
      return trainings.count
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 && indexPath.row == 0{
      let width = tableView.frame.width
      return width / CGFloat(trainer.1)
    } else if indexPath.section == 0 && indexPath.row != 0{
      let width = tableView.frame.width
      return width / CGFloat(stuff[indexPath.row - 1].1)
    } else {
      let width = tableView.frame.width - 16
      return width / CGFloat(trainings[indexPath.row].1)
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCellWithIdentifier("titleCell") else {
        return UITableViewCell()
      }
      
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        let imageName = indexPath.row == 0 ? trainer.0 : stuff[indexPath.row - 1].0
        imageView.image = UIImage(named: imageName)
      }
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCellWithIdentifier("programCell") else {
        return UITableViewCell()
      }
      
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        let imageName = trainings[indexPath.row].0
        imageView.image = UIImage(named: imageName)
      }
      
      cell.backgroundColor = UIColor.lightGrayBackgroundColor()
      
      return cell
    }
  }
}
