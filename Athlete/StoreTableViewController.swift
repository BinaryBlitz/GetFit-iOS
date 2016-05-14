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
import Reusable

class StoreTableViewController: UITableViewController {

  var programs = [Program]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    configureTableView()
    fetchPrograms()
  }
  
  func configureTableView() {
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    tableView.registerReusableCell(ProgramTableViewCell)
    
    tableView.backgroundView = createBackgroundView()
    tableView.rowHeight = 320
    
    let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
    header.backgroundColor = UIColor.clearColor()
    tableView.tableHeaderView = header
    
    refresh()
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  func createBackgroundView() -> UIView {
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
  }
  
  func fetchPrograms() {
    let realm = try! Realm()
    programs = Array(realm.objects(Program).sorted("usersCount"))
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    ServerManager.sharedManager.fetchPrograms { (response) in
      switch response.result {
      case .Success(let programs):
        self.programs = programs
        let realm = try! Realm()
        try! realm.write {
          realm.add(programs, update: true)
        }
      case .Failure(let error):
        print(error)
      }
      completion()
    }
  }
  
  //MARK: - TableView DataSource and Delegate
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = programs.count
    tableView.backgroundView?.hidden = numberOfRows != 0
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let program = programs[indexPath.row]
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProgramTableViewCell
    cell.configureWith(ProgramViewModel(program: program))
    cell.state = .Card
    cell.delegate = self
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("programDetails", sender: indexPath)
  }
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else { return }
    switch identifier {
    case "programDetails":
      let destination = segue.destinationViewController as! ProgramDetailsTableViewController
      let indexPath = sender as! NSIndexPath
      destination.program = programs[indexPath.row]
    default:
      break
    }
  }
}

//MARK: - ProgramCellDelegate

extension StoreTableViewController: ProgramCellDelegate {
  func didTouchBuyButtonInCell(cell: ProgramTableViewCell) {
    self.presentAlertWithMessage("gimme da progam b0ss")
  }
}
