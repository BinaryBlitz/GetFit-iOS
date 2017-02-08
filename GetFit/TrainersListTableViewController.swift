//
//  TrainersListTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
import Reusable

protocol TrainersListDelegate: class {
  func trainersList(viewController: TrainersListTableViewController, didSelectTrainer trainer: Trainer)
}

class TrainersListTableViewController: UITableViewController {
  
  var category: TrainerCategory = .Coach
  var trainers: Results<Trainer>?

  weak var delegate: TrainersListDelegate?

  convenience init(category: TrainerCategory) {
    self.init()
    self.category = category
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerReusableCell(ProfessionalTableViewCell)
    tableView.rowHeight = 370
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let realm = try! Realm()

    //TODO: sort by popularity
    trainers = realm.objects(Trainer).filter("categoryValue = '\(category.rawValue)'").sorted("id")
  }

  //MARK: - UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainers?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let trainer = trainers?[indexPath.row] else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProfessionalTableViewCell
    cell.configureWith(trainer)
    
    return cell
  }

  //MARK: - UITableViewDelegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    if let trainer = trainers?[indexPath.row] {
      delegate?.trainersList(self, didSelectTrainer: trainer)
    }

    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
