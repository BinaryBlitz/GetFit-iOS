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
    settings.style.buttonBarItemFont = UIFont.boldSystemFontOfSize(15)
    settings.style.selectedBarHeight = 0
    settings.style.buttonBarItemTitleColor = UIColor.blackTextColor()
    settings.style.buttonBarItemsShouldFillAvailiableWidth = false
  
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
           progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = UIColor.graySecondaryColor()
        newCell?.label.textColor = UIColor.blackTextColor()
    }
    
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: Selector(nilLiteral: ()))
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
  }
  
  // MARK: - PagerTabStripDataSource
  
  override func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let coaches = TrainersListTableViewController(category: .Coach)
    let doctors = TrainersListTableViewController(category: .Doctor)
    let nutritionists = TrainersListTableViewController(category: .Nutritionist)
    let pages: [TrainersListTableViewController] = [coaches, nutritionists, doctors]
    pages.forEach { page in
      page.delegate = self
    }

    return [coaches, nutritionists, doctors]
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? ProfessionalTableViewController,
        trainer = sender as? Trainer
        where segue.identifier == "professionalInfo" {
      destination.trainer = trainer
    }
  }
}

extension ProfessionalsViewController: TrainersListDelegate {

  func trainersList(viewController: TrainersListTableViewController, didSelectTrainer trainer: Trainer) {
    performSegueWithIdentifier("professionalInfo", sender: trainer)
  }
}
