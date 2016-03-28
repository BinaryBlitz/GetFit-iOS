//
//  ProfessionalTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 05/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import Haneke
import PureLayout

class ProfessionalTableViewCell: UITableViewCell {
  
  enum ProfessionalCellState {
    case Normal
    case Card
  }
  
  var state: ProfessionalCellState = .Card {
    didSet {
      updateWithState(state)
    }
  }

  @IBOutlet weak var cardView: CardView!
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var programsBadge: BadgeView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var avatarImageView: CircleImageView!
  @IBOutlet weak var followBadge: BadgeView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = .lightGrayBackgroundColor()
    avatarImageView.contentMode = UIViewContentMode.ScaleAspectFill
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
    avatarImageView.layer.borderWidth = 3
    bannerImageView.contentMode = UIViewContentMode.ScaleAspectFill
    bannerImageView.layer.masksToBounds = true
  }
  
  func configureWith(trainer: Trainer, andState state: ProfessionalCellState = .Card) {
    resetImages()
    nameLabel.text = "\(trainer.firstName) \(trainer.lastName)"
    if state == .Card {
      programsBadge.text = "10 programs".uppercaseString
    } else {
      programsBadge.text = trainer.category.rawValue.uppercaseString
    }
    
    let avatarURL = NSURL(string: trainer.avatarURLString)
    let bannerURL = NSURL(string: "https://pbs.twimg.com/media/Cc3s9UQVIAA0IWP.jpg")
    if let url = avatarURL {
      avatarImageView.hnk_setImageFromURL(url)
    }
    if let url = bannerURL {
      bannerImageView.hnk_setImageFromURL(url)
    }
    
    followBadge.style = BadgeView.Style(color: .LightBlue, height: .Tall)
    followBadge.fontSize = 15
    followBadge.text = "+ follow".uppercaseString
    
    self.state = state
  }
  
  private func resetImages() {
    avatarImageView.hnk_cancelSetImage()
    bannerImageView.hnk_cancelSetImage()
    avatarImageView.image = nil
    bannerImageView.image = nil
  }
  
  private func updateWithState(state: ProfessionalCellState) {
    switch state {
    case .Card:
      cardView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 7, left: 11, bottom: 7, right: 11))
    case .Normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}
