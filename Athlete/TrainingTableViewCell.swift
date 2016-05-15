//
//  TrainingTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell
import Reusable

class TrainingTableViewCell: MCSwipeTableViewCell, NibReusable {
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var badgesStackView: UIStackView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel.textColor = UIColor.blueAccentColor()
    defaultColor = UIColor.graySecondaryColor()
    
    let dateBadge = BadgeView()
    dateBadge.style = BadgeView.Style(color: .Dark, height: .Low)
    badgesStackView.addArrangedSubview(dateBadge)
    
    let durationBadge = BadgeView()
    durationBadge.style = BadgeView.Style(color: .LightGray, height: .Low)
    badgesStackView.addArrangedSubview(durationBadge)
  }
  
  func configureWith(viewModel: TrainingPresentable) {
    titleLabel.text = viewModel.trainingTitle
    
    updateInfoLabelWithTitle(viewModel.trainingInfo, andSubtitle: "\(viewModel.trainingExercisesCount) exercises")
    
    if let dateBadge = badgesStackView.arrangedSubviews.first as? BadgeView {
      dateBadge.text = viewModel.trainingDateString
    }
    
    if let durationBadge = badgesStackView.arrangedSubviews.last as? BadgeView {
      durationBadge.text = viewModel.trainingDurationString
    }
  }
  
  private func updateInfoLabelWithTitle(title: String, andSubtitle subtitle: String) {
    let infoFontSize: CGFloat = 15
    let boldTextAttrebutes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(infoFontSize)]
    let infoString = NSMutableAttributedString(string: title, attributes:boldTextAttrebutes)
    let plainTextAttrebutes = [NSFontAttributeName : UIFont.systemFontOfSize(infoFontSize)]
    infoString.appendAttributedString(NSMutableAttributedString(string: ", \(subtitle)", attributes: plainTextAttrebutes))
    infoLabel.attributedText = infoString
  }
  
  //FIXME: 😢😭
  func configureWith(workout: Workout) {
    titleLabel.text = workout.programName
    updateInfoLabelWithTitle(workout.name, andSubtitle: "\(workout.exercisesCount) exercises")
    
    //remove all badges
    for subview in badgesStackView.arrangedSubviews {
      badgesStackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }
    
    let durationBadge = BadgeView()
    durationBadge.style = BadgeView.Style(color: .LightGray, height: .Low)
    durationBadge.text = "\(workout.duration) MIN"
    badgesStackView.addArrangedSubview(durationBadge)
  }
}
