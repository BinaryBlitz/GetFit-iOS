//
//  ProfileTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    
    tableView.registerNib(UINib(nibName: String(ProfileCardTableViewCell), bundle: nil), forCellReuseIdentifier: "profileCard")
    tableView.tableHeaderView = tableView.dequeueReusableCellWithIdentifier("profileCard")
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
  }
  
  //MARK: - UITableViewDataSource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 5
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("stuff") else {
      return UITableViewCell()
    }
    
    return cell
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "section #\(section)"
  }
//  
//  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    guard section == 0 else {
//      return nil
//    }
//    
//    return UIView()
//  }
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    guard let navigationBarHidden = navigationController?.navigationBarHidden else {
      return
    }
    
//    if navigationBarHidden {
//      if scrollView.contentOffset.y >= 130 {
//        self.navigationController?.presentTransparentNavigationBar()
//      }
//    } else {
//      if scrollView.contentOffset.y < 130 {
//        UIView.animateWithDuration(0.3) {
//          self.navigationController?.hideTransparentNavigationBar()
//        }
//      }
//    }
  }
}
