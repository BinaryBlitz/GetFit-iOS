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
    
    let infoFontSize: CGFloat = 15
    let boldTextAttrebutes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(infoFontSize)]
    let infoString = NSMutableAttributedString(string:viewModel.trainingInfo, attributes:boldTextAttrebutes)
    let plainTextAttrebutes = [NSFontAttributeName : UIFont.systemFontOfSize(infoFontSize)]
    infoString.appendAttributedString(NSMutableAttributedString(string: ", \(viewModel.trainingExercisesCount)", attributes: plainTextAttrebutes))
    infoLabel.attributedText = infoString
    
    if let dateBadge = badgesStackView.arrangedSubviews.first as? BadgeView {
      dateBadge.text = viewModel.trainingDateString
    }
    
    if let durationBadge = badgesStackView.arrangedSubviews.last as? BadgeView {
      durationBadge.text = viewModel.trainingDurationString
    }
  }
}
