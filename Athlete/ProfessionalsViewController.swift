//
//  ProfessionalsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProfessionalsViewController: UIViewController {
  
  let dudes = [("dude1", 1.01), ("dude2", 1.01), ("dude3", 1.01)]
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? ProfessionalTableViewController,
        indexPath = sender as? NSIndexPath where segue.identifier == "professionalInfo" {
      destination.trainer = dudes[indexPath.row]
    }
  }
}

extension ProfessionalsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dudes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("professionalCell") as? ProfessionalTableViewCell else {
      return UITableViewCell()
    }
    
    cell.contentImageView.image = UIImage(named: dudes[indexPath.row].0)
    cell.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let width = tableView.frame.width - 16
    
    return width / CGFloat(dudes[indexPath.row].1)
  }
}

extension ProfessionalsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("professionalInfo", sender: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}