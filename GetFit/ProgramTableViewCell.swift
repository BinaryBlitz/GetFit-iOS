//
//  ProgramTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher
import Reusable

typealias ProgramCellPresentable = TrainerPresentable & ProgramPresentable & NamedObject

protocol ProgramCellDelegate: class {
  func didTouchBuyButtonInCell(_ cell: ProgramTableViewCell)
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
    case card
    case normal
  }
  
  var state: ProgramCellState = .card {
    didSet {
      updateWithState(state)
    }
  }
  
  weak var delegate: ProgramCellDelegate?
  
  func hideBanner() {
    bannerView.removeFromSuperview()
    contentStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 14)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
    priceBadge.style = BadgeView.Style(color: .lightBlue, height: .tall)
    categoryBadge.style = BadgeView.Style(color: .lightGray)
    
    trainerAvatar.layer.borderColor = UIColor.white.cgColor
    trainerAvatar.layer.borderWidth = 1
    trainerAvatar.image = EmptyStateHelper.avatarPlaceholderImage
    
    let buyButton = UIButton()
    priceBadge.addSubview(buyButton)
    buyButton.autoPinEdgesToSuperviewEdges()
    buyButton.addTarget(self, action: #selector(buyButtonAction(_:)), for: .touchUpInside)
    
    let maskView = UIView()
    maskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    bannerImageView.addSubview(maskView)
    maskView.autoPinEdgesToSuperviewEdges()
    bannerMaskView = maskView
  }
  
  //MARK: - Actions
  
  func buyButtonAction(_ button: UIButton) {
    delegate?.didTouchBuyButtonInCell(self)
  }
  
  //MARK: - Cell configuration
  
  func configureWith(_ viewModel: ProgramCellPresentable) {
    nameLabel.text = viewModel.title
    priceBadge.text = viewModel.price
    infoLabel.attributedText = viewModel.info
    categoryBadge.text = viewModel.category
    
    if state == .card {
      descriptionLabel.text = viewModel.preview
    } else {
      descriptionLabel.text = viewModel.description
    }
    followersLabel.text = viewModel.followers
    ratingLabel.text = viewModel.rating
    
    trainerNameLabel.text = viewModel.trainerName
    
    trainerAvatar.kf.cancelDownloadTask()
    if let avatarURL = viewModel.trainerAvatarURL {
      trainerAvatar.kf.setImage(with: avatarURL)
    }
    
    bannerImageView.kf.cancelDownloadTask()
    bannerMaskView?.isHidden = true
    bannerImageView.image = EmptyStateHelper.generateBannerImageFor(viewModel)
    if let bannerURL = viewModel.bannerURL {
      bannerImageView.kf.setImage(with: bannerURL) { image, _, _, _ in
        self.bannerImageView.image = image
        self.bannerMaskView?.isHidden = false
      }
    }
  }
  
  fileprivate func updateWithState(_ state: ProgramCellState) {
    switch state {
    case .card:
      cardView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    case .normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}
