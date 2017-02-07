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
import Reusable

typealias ProgramCellPresentable = protocol<TrainerPresentable, ProgramPresentable, NamedObject>

protocol ProgramCellDelegate: class {
  func didTouchBuyButtonInCell(cell: ProgramTableViewCell)
}

class ProgramTableViewCell: UITableViewCell, NibReusable {
  
  //MARK: - Base
  @IBOutlet weak var cardView: CardView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceBadge: BadgeView!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var trainerNameLabel: UILabel!
  @IBOutlet weak var trainerAvatar: CircleImageView!
  @IBOutlet weak var bannerImageView: UIImageView!
  
  @IBOutlet weak var categoryBadge: BadgeView!
  
  @IBOutlet weak var bannerView: UIView!
  @IBOutlet weak var contentStackView: UIStackView!
  
  var bannerMaskView: UIView?
  
  enum ProgramCellState {
    case Card
    case Normal
  }
  
  var state: ProgramCellState = .Card {
    didSet {
      updateWithState(state)
    }
  }
  
  weak var delegate: ProgramCellDelegate?
  
  func hideBanner() {
    bannerView.removeFromSuperview()
    contentStackView.autoPinEdgeToSuperviewEdge(.Top, withInset: 14)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
    priceBadge.style = BadgeView.Style(color: .LightBlue, height: .Tall)
    categoryBadge.style = BadgeView.Style(color: .LightGray)
    
    trainerAvatar.layer.borderColor = UIColor.whiteColor().CGColor
    trainerAvatar.layer.borderWidth = 1
    trainerAvatar.image = EmptyStateHelper.avatarPlaceholderImage
    
    let buyButton = UIButton()
    priceBadge.addSubview(buyButton)
    buyButton.autoPinEdgesToSuperviewEdges()
    buyButton.addTarget(self, action: #selector(buyButtonAction(_:)), forControlEvents: .TouchUpInside)
    
    let maskView = UIView()
    maskView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
    bannerImageView.addSubview(maskView)
    maskView.autoPinEdgesToSuperviewEdges()
    bannerMaskView = maskView
  }
  
  //MARK: - Actions
  
  func buyButtonAction(button: UIButton) {
    delegate?.didTouchBuyButtonInCell(self)
  }
  
  //MARK: - Cell configuration
  
  func configureWith(viewModel: ProgramCellPresentable) {
    nameLabel.text = viewModel.title
    priceBadge.text = viewModel.price
    infoLabel.attributedText = viewModel.info
    categoryBadge.text = viewModel.category
    
    if state == .Card {
      descriptionLabel.text = viewModel.preview
    } else {
      descriptionLabel.text = viewModel.description
    }
    followersLabel.text = viewModel.followers
    ratingLabel.text = viewModel.rating
    
    trainerNameLabel.text = viewModel.trainerName
    
    trainerAvatar.hnk_cancelSetImage()
    if let avatarURL = viewModel.trainerAvatarURL {
      trainerAvatar.hnk_setImageFromURL(avatarURL)
    }
    
    bannerImageView.hnk_cancelSetImage()
    bannerMaskView?.hidden = true
    bannerImageView.image = EmptyStateHelper.generateBannerImageFor(viewModel)
    if let bannerURL = viewModel.bannerURL {
      bannerImageView.hnk_setImageFromURL(bannerURL) { image in
        self.bannerImageView.image = image
        self.bannerMaskView?.hidden = false
      }
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
