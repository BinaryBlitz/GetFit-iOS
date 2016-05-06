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
    parametersStackView.removeAllSubviews()
    
    if session.reps > 0 {
      let repsView = loadExerciseParamsViewFor(ExerciseParameter(name: "reps", value: session.reps))
      parametersStackView.addArrangedSubview(repsView)
    }
    
    if session.distance > 0 {
      let distView = loadExerciseParamsViewFor(ExerciseParameter(name: "distance, km", value: session.distance))
      parametersStackView.addArrangedSubview(distView)
    }
    
    if session.sets > 0 {
      let setsView = loadExerciseParamsViewFor(ExerciseParameter(name: "sets", value: session.sets))
      parametersStackView.addArrangedSubview(setsView)
    }
    
    if session.weight > 0 {
      let weightView = loadExerciseParamsViewFor(ExerciseParameter(name: "weight, kg", value: session.weight))
      parametersStackView.addArrangedSubview(weightView)
    }
  }
  
  private func loadExerciseParamsViewFor(parameter: ExerciseParameter) -> ExerciseParamsView {
    let view = NSBundle.mainBundle().loadNibNamed(String(ExerciseParamsView), owner: self, options: nil).first as! ExerciseParamsView
    view.configureWithExerciseParameter(parameter)
    return view
  }
}
