//
//  StoreTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class StoreTableViewController: UITableViewController {

  let trainings = [("training1", 1.01), ("training2", 0.96), ("training3", 1.09)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
    
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 16))
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainings.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("trainingCell") as? TrainingProgramTableViewCell else {
      return UITableViewCell()
    }
    
    cell.contentImageView.image = UIImage(named: trainings[indexPath.row].0)
    cell.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let width = tableView.frame.width - 16
    
    return width / CGFloat(trainings[indexPath.row].1)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("trainingDetails", sender: indexPath)
  }
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? TrainingProgramTableViewController,
        indexPath = sender as? NSIndexPath
        where segue.identifier == "trainingDetails" {
      destination.training = trainings[indexPath.row]
    }
  }
}
