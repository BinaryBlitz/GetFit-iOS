//
//   WorkoutHeaderView.swift
//   Athlete
//
//   Created by Dan Shevlyuk on 18/05/2016.
//   Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class WorkoutHeaderView: UITableViewHeaderFooterView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var durationBadge: BadgeView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.clearColor()
    titleLabel.textColor = UIColor.darkGrayColor()
  }
  
  func configureWith(workout: Workout) {
    titleLabel.text = workout.name
    durationBadge.text = "\(workout.duration) MIN"
    durationBadge.style = BadgeView.Style(color: .LightGray, height: .Low)
  }
}
