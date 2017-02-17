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
    contentView.backgroundColor = UIColor.clear
    titleLabel.textColor = UIColor.darkGray
  }
  
  func configureWith(_ workout: Workout) {
    titleLabel.text = workout.name
    durationBadge.text = "\(workout.duration) MIN"
    durationBadge.style = BadgeView.Style(color: .lightGray, height: .low)
  }
}
