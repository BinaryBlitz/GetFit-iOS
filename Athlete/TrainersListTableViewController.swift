//
//  TrainersListTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class TrainersListTableViewController: UITableViewController {
  
  var category: TrainerCategory = .Coach
  var trainers: Results<Trainer>?
  
  convenience init(category: TrainerCategory) {
    self.init()
    self.category = category
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let trainerCellNib = UINib(nibName: String(ProfessionalTableViewCell), bundle: nil)
    tableView.registerNib(trainerCellNib, forCellReuseIdentifier: String(ProfessionalTableViewCell))
//    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.rowHeight = 370
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let realm = try! Realm()
    trainers = realm.objects(Trainer).sorted("id")
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainers?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier(String(ProfessionalTableViewCell)) as? ProfessionalTableViewCell,
        trainer = trainers?[indexPath.row] else {
      return UITableViewCell()
    }
    
    cell.configureWith(trainer)
    
    return cell
  }
}

extension TrainersListTableViewController: IndicatorInfoProvider {
  func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: category.pluralName().uppercaseString)
  }
}

