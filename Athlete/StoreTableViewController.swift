//
//  StoreTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
import PureLayout

class StoreTableViewController: UITableViewController {

  var programs: Results<Program>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 16))
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let programCellNib = UINib(nibName: String(ProgramTableViewCell), bundle: nil)
    tableView.registerNib(programCellNib, forCellReuseIdentifier: String(ProgramTableViewCell))
    
    tableView.backgroundView = {
      let view = UIView()
      let label = UILabel()
      label.text = "No data 😓"
      label.textAlignment = .Center
      label.font = UIFont.systemFontOfSize(22)
      label.textColor = UIColor.graySecondaryColor()
      view.addSubview(label)
      label.autoPinEdgeToSuperviewEdge(.Left)
      label.autoPinEdgeToSuperviewEdge(.Right)
      label.autoPinEdgeToSuperviewEdge(.Bottom)
      label.autoPinEdgeToSuperviewEdge(.Top, withInset: -50, relation: .Equal)
      return view
    }()
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return programs?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let programCellId = String(ProgramTableViewCell)
    let cell = tableView.dequeueReusableCellWithIdentifier(programCellId) as! ProgramTableViewCell
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("trainingDetails", sender: indexPath)
  }
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? TrainingProgramTableViewController,
        indexPath = sender as? NSIndexPath
        where segue.identifier == "programDetails" {
//      destination.training = programs?[indexPath.row]
    }
  }
}
