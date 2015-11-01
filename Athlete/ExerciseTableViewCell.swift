//
//  ExerciseTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: MCSwipeTableViewCell {

  @IBOutlet weak var repetitionsButton: UIButton!
  @IBOutlet weak var weightButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    [repetitionsButton, weightButton].forEach { (button) -> () in
      button.layer.cornerRadius = 3
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.blueAccentColor().CGColor
      button.backgroundColor = nil
      button.tintColor = UIColor.blueAccentColor()
      button.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
    }
    
    titleLabel.textColor = UIColor.blackTextColor()
    defaultColor = UIColor.greenAccentColor()
  }
}
