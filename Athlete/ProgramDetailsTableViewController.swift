//
//  ProgramDetailsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProgramDetailsTableViewController: UITableViewController {
  
  var program: Program!
  var exercises = ["Push Ups", "Turns", "Body Blast", "Power Ups"]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let programCellNib = UINib(nibName: String(ProgramTableViewCell), bundle: nil)
    tableView.registerNib(programCellNib, forCellReuseIdentifier: String(ProgramTableViewCell))
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
      let cell = tableView.dequeueReusableCellWithIdentifier(String(ProgramTableViewCell)) as! ProgramTableViewCell
      cell.configureWith(ProgramViewModel(program: program))
      cell.state = .Normal
      cell.delegate = self
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell") else {
        return UITableViewCell()
      }
      
      if indexPath.row < 2 {
        cell.textLabel?.text = exercises[indexPath.row]
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
    
    return 10
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 400
    default:
      return 44
    }
  }
}

extension ProgramDetailsTableViewController: ProgramCellDelegate {
  func didTouchBuyButtonInCell(cell: ProgramTableViewCell) {
    self.presentAlertWithMessage("gimme da progam b0ss")
  }
}