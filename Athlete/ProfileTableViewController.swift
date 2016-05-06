//
//  ProfileTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Reusable
import RealmSwift

class ProfileTableViewController: UITableViewController {
  
  private let tabsLabels = ["statistic", "programs"]
  private var selectedTabIndex = 0
  
  var programs: Results<Program>?
  var user: User!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    
    let realm = try! Realm()
    programs = realm.objects(Program)
  }
  
  private func setupTableView() {
    tableView.registerReusableCell(ProfileCardTableViewCell)
    tableView.registerReusableCell(ProgramTableViewCell)
    tableView.registerReusableCell(StatisticsTableViewCell)
    
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    completion()
  }
  
  //MARK: - UITableViewDataSource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1 where selectedTabIndex == 0:
      return 1
    case 1 where selectedTabIndex == 1:
      if let programs = programs {
        return programs.count
      } else {
        return 0
      }
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProfileCardTableViewCell
      
      return cell
    case 1 where selectedTabIndex == 0:
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as StatisticsTableViewCell
      return cell
    case 1 where selectedTabIndex == 1:
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProgramTableViewCell
      cell.state = .Card
      let program = programs![indexPath.row]
      cell.configureWith(ProgramViewModel(program: program))
      
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 300
    case 1 where selectedTabIndex == 0:
      return tableView.frame.width
    case 1 where selectedTabIndex == 1:
      return 320
    default:
      return 0
    }
  }
  
  //MARK: - UITableViewDelegate
  
  //MARK: - Header configuration
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 1 else { return nil }
    
    let labels = tabsLabels.map { $0.uppercaseString }
    let buttonStrip = ButtonsStripView(labels: labels)
    buttonStrip.delegate = self
    buttonStrip.selectedIndex = selectedTabIndex
    
    return buttonStrip
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard section == 1 else { return 0 }
    return 50
  }
}

extension ProfileTableViewController: ButtonStripViewDelegate {
  
  func stripView(view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedTabIndex = index
    let offset = tableView.contentOffset
    tableView.reloadData()
    if tableView.numberOfRowsInSection(index) >= 2 {
      tableView.setContentOffset(offset, animated: true)
    } else {
      tableView.setContentOffset(CGPoint.zero, animated: true)
    }
  }
}
