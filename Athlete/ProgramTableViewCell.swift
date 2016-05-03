//
//  ProgramTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PureLayout
import Haneke

typealias ProgramCellPresentable = protocol<TrainerPresentable, ProgramPresentable>

class ProgramTableViewCell: UITableViewCell {
  
  //MARK: - Base
  @IBOutlet weak var cardView: CardView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceBadge: BadgeView!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var durationBadge: BadgeView!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var trainerNameLabel: UILabel!
  @IBOutlet weak var trainerAvatar: CircleImageView!
  @IBOutlet weak var bannerImageView: UIImageView!
  
  enum ProgramCellState {
    case Card
    case Normal
  }
  
  var state: ProgramCellState = .Card {
    didSet {
      updateWithState(state)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
    priceBadge.style = BadgeView.Style(color: .LightBlue, height: .Tall)
    durationBadge.style = BadgeView.Style(color: .LightGray, height: .Low)
    trainerAvatar.layer.borderColor = UIColor.whiteColor().CGColor
    trainerAvatar.layer.borderWidth = 1
  }
  
  //MARK: - Cell configuration
  
  func configureWith(viewModel: ProgramCellPresentable) {
    nameLabel.text = viewModel.title
    priceBadge.text = viewModel.price
    let infoFontSize: CGFloat = 15
    let boldTextAttrebutes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(infoFontSize)]
    let infoString = NSMutableAttributedString(string:viewModel.category.capitalizedString, attributes:boldTextAttrebutes)
    let plainTextAttrebutes = [NSFontAttributeName : UIFont.systemFontOfSize(infoFontSize)]
    infoString.appendAttributedString(NSMutableAttributedString(string: ", \(viewModel.exercisesCount)", attributes: plainTextAttrebutes))
    infoLabel.attributedText = infoString
    
    descriptionLabel.text = viewModel.description
    durationBadge.text = viewModel.duration
    followersLabel.text = viewModel.followers
    ratingLabel.text = viewModel.rating
    
    trainerNameLabel.text = viewModel.trainerName
    
    trainerAvatar.hnk_cancelSetImage()
    if let avatarURL = viewModel.trainerAvatarURL {
      trainerAvatar.hnk_setImageFromURL(avatarURL)
    }
    
    bannerImageView.hnk_cancelSetImage()
    if let bannerURL = viewModel.bannerURL {
      bannerImageView.hnk_setImageFromURL(bannerURL)
    }
  }
  
  private func updateWithState(state: ProgramCellState) {
    switch state {
    case .Card:
      cardView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    case .Normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}
