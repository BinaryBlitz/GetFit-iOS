//
//  ProfessionalsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ProfessionalsViewController: ButtonBarPagerTabStripViewController {
  
  override func viewDidLoad() {
    
    settings.style.buttonBarBackgroundColor = UIColor.lightGrayBackgroundColor()
    settings.style.buttonBarItemBackgroundColor = UIColor.lightGrayBackgroundColor()
//        settings.style.selectedBarBackgroundColor = UIColor(red: 33/255.0, green: 174/255.0, blue: 67/255.0, alpha: 1.0)
    settings.style.buttonBarItemFont = UIFont.boldSystemFontOfSize(15)
    settings.style.selectedBarHeight = 0
    settings.style.buttonBarMinimumInteritemSpacing = 0
    settings.style.buttonBarItemTitleColor = UIColor.blackTextColor()
    settings.style.buttonBarItemsShouldFillAvailiableWidth = false
  
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = UIColor.graySecondaryColor()
        newCell?.label.textColor = UIColor.blackTextColor()
    }
    
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
  }
  
  // MARK: - PagerTabStripDataSource
  
  override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let coaches = TrainersListTableViewController(category: .Coach)
    let doctors = TrainersListTableViewController(category: .Doctor)
    let nutritionists = TrainersListTableViewController(category: .Nutritionist)
    
    return [coaches, nutritionists, doctors]
  }
}
