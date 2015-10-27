//
//  TrainingTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class TrainingTableViewCell: MCSwipeTableViewCell {
  
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var dateView: UIView!
  @IBOutlet weak var durationView: UIView!
  @IBOutlet weak var exersizesLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    dateView.backgroundColor = UIColor.graySecondaryColor()
    dateView.layer.cornerRadius = 3
    
    durationView.layer.borderWidth = 1
    durationView.layer.cornerRadius = 3
    durationView.layer.borderColor = UIColor.graySecondaryColor().CGColor
    durationView.backgroundColor = UIColor.whiteColor()
    
    titleLabel.textColor = UIColor.blueAccentColor()
    
    durationLabel.textColor = UIColor.graySecondaryColor()
  }
}