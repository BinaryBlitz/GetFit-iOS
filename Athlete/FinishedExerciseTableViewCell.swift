//
//  FinishedExerciseTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 29/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class FinishedExerciseTableViewCell: MCSwipeTableViewCell {

  @IBOutlet weak var repetitionsButton: UIButton!
  @IBOutlet weak var weightButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    [repetitionsButton, weightButton].forEach { (button) -> () in
      button.layer.cornerRadius = 3
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.graySecondaryColor().CGColor
      button.backgroundColor = nil
      button.tintColor = UIColor.graySecondaryColor()
      button.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
    }
    
    titleLabel.textColor = UIColor.graySecondaryColor()
    defaultColor = UIColor.primaryYellowColor()
  }
  
  func hideWeight(hide: Bool) {
  }
}
