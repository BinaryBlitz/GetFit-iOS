//
//  ProfessionalTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 02/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProfessionalTableViewController: UITableViewController {
  
  var trainer: Trainer!
  private let tabsLabels = ["programs", "news"]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
  }
  
  func configureTableView() {
    let trainerInfoCellNib = UINib(nibName: String(ProfessionalTableViewCell), bundle: nil)
    tableView.registerNib(trainerInfoCellNib, forCellReuseIdentifier: "infoHeader")
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 1
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("infoHeader") as! ProfessionalTableViewCell
      cell.configureWith(trainer, andState: .Normal)
      return cell
    case 1:
      //TODO: - return programs, news and reviews
      return UITableViewCell()
    default:
      return UITableViewCell()
    }
  }

  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    switch section {
    case 0:
      return nil
    case 1:
      let buttonStrip = ButtonsStripView(labels: tabsLabels)
      buttonStrip.delegate = self
      
      return buttonStrip
    default:
      return nil
    }
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 70
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return indexPath.row == 0 ? 320 : 40
    case 1:
      return UITableViewAutomaticDimension
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return indexPath.row == 0 ? 350 : 40
    case 1:
      return 400
    default:
      return 0
    }
  }
}

extension ProfessionalTableViewController: ButtonStripViewDelegate {
  func stripView(view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    print("index selected: \(index)")
  }
}