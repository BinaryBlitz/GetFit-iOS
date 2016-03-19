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

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
  }
  
  func configureTableView() {
    let trainerInfoCellNib = UINib(nibName: String(ProfessionalTableViewCell), bundle: nil)
    tableView.registerNib(trainerInfoCellNib, forCellReuseIdentifier: "infoHeader")
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
  }

  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableCellWithIdentifier("infoHeader") as! ProfessionalTableViewCell
    header.configureWith(trainer, andState: .Normal)
    
    return header
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 370
  }
}