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
    configureTableView()
    fetchPrograms()
  }
  
  func configureTableView() {
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
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
    headerView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.tableHeaderView = headerView
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  func fetchPrograms() {
    let realm = try! Realm()
    //TODO: add programs sorting
    programs = realm.objects(Program)
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.fetchPrograms()
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    completion()
  }
  
  //MARK: - TableView DataSource and Delegate
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = programs?.count ?? 0
    tableView.backgroundView?.hidden = numberOfRows != 0
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let program = programs?[indexPath.row] else {
      return UITableViewCell()
    }
    
    let programCellId = String(ProgramTableViewCell)
    let cell = tableView.dequeueReusableCellWithIdentifier(programCellId) as! ProgramTableViewCell
    cell.state = .Card
    cell.configureWith(ProgramViewModel(program: program))
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    performSegueWithIdentifier("trainingDetails", sender: indexPath)
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
