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

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//    navigationController?.navigationBar.shadowImage = UIImage()
//    navigationController?.navigationBar.translucent = true
//    navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
  }
  
  override func viewDidDisappear(animated: Bool) {
    
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
  }
}
