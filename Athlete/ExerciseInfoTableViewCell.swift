//
//  ExerciseInfoTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 06/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class ExerciseInfoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var showTipsButton: UIButton!
  @IBOutlet weak var parametersStackView: UIStackView!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    showTipsButton.backgroundColor = UIColor.blueAccentColor()
  }
  
  func configureWith(session: ExerciseSession) {
    let repsView = NSBundle.mainBundle().loadNibNamed(String(ExerciseParamsView), owner: self, options: nil).first as! ExerciseParamsView
    repsView.configureWithExerciseParameter(ExerciseParameter(name: "reps".uppercaseString, value: String(session.reps)))
    parametersStackView.addArrangedSubview(repsView)
  }
}
