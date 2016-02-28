//
//  TrainersListTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TrainersListTableViewController: UITableViewController {
  
  var category: TrainerCategory = .Coach
  
  convenience init(category: TrainerCategory) {
    self.init()
    self.category = category
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension TrainersListTableViewController: IndicatorInfoProvider {
  func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: category.pluralName().uppercaseString)
  }
}

