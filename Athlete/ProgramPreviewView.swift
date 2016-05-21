//
//  ProgramPreviewView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 21/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class ProgramPreviewView: UIView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var priceBadge: BadgeView!
  @IBOutlet weak var contentView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.layer.cornerRadius = 5
    contentView.layer.borderWidth = 0.8
    contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
    titleLabel.textColor = UIColor.blueAccentColor()
  }
  
  func configureWith(program: ProgramPresentable) {
    titleLabel.text = program.title
    infoLabel.attributedText = program.info
    priceBadge.style = BadgeView.Style(color: .LightBlue, height: .Tall)
    priceBadge.text = program.price
  }
}
