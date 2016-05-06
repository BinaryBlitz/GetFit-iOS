//
//  ExerciseParamsView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 06/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PureLayout

struct ExerciseParameter {
  let name: String
  let value: Int
}

class ExerciseParamsView: UIStackView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var separatorViewHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    separatorViewHeightConstraint.constant = 1 / UIScreen.mainScreen().scale
    separatorView.backgroundColor = UIColor.graySecondaryColor()
    titleLabel.textColor = UIColor.graySecondaryColor()
    valueLabel.textColor = UIColor.blackTextColor()
  }
  
  func configureWithExerciseParameter(parameter: ExerciseParameter) {
    titleLabel.text = parameter.name.uppercaseString
    updateValue(parameter.value)
  }
  
  func updateValue(value: Int) {
    valueLabel.text = String(value)
  }
}