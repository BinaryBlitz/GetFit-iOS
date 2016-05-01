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
  
  @IBOutlet weak var followButtonBackground: UIView!
  @IBOutlet weak var followButtonIcon: UIImageView!
  @IBOutlet weak var followButtonLabel: UILabel!
  
  private var following: Bool = false {
    didSet {
      updateFollowingStatus(following)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = .lightGrayBackgroundColor()
    avatarImageView.contentMode = UIViewContentMode.ScaleAspectFill
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
    avatarImageView.layer.borderWidth = 3
    bannerImageView.contentMode = UIViewContentMode.ScaleAspectFill
    bannerImageView.layer.masksToBounds = true
    
    setupFollowButton()
    updateFollowingStatus(following)
  }
  
  func setupFollowButton() {
    let button = UIButton()
    followButtonBackground.addSubview(button)
    button.autoPinEdgesToSuperviewEdges()
    button.addTarget(self, action: #selector(followButtonAction(_:)), forControlEvents: .TouchUpInside)
    followButtonBackground.layer.borderWidth = 1
    followButtonBackground.layer.cornerRadius = 2
    followButtonLabel.text = "follow".uppercaseString
  }
  
  func followButtonAction(sender: UIButton) {
    //TODO: add follow request
    following = !following
  }
  
  func updateFollowingStatus(following: Bool) {
    if following {
      followButtonLabel.textColor = UIColor.whiteColor()
      followButtonIcon.tintColor = UIColor.whiteColor()
      followButtonIcon.image = UIImage(named: "Checkmark")?.imageWithRenderingMode(.AlwaysTemplate)
      followButtonBackground.backgroundColor = UIColor.blueAccentColor()
      followButtonBackground.layer.borderColor = UIColor.blueAccentColor().CGColor
    } else {
      followButtonLabel.textColor = UIColor.blueAccentColor()
      followButtonIcon.tintColor = UIColor.blueAccentColor()
      followButtonIcon.image = UIImage(named: "Add")?.imageWithRenderingMode(.AlwaysTemplate)
      followButtonBackground.backgroundColor = UIColor.whiteColor()
      followButtonBackground.layer.borderColor = UIColor.blueAccentColor().CGColor
    }
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
      cardView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    case .Normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}
