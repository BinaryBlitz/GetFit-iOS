//
//  PostCommentTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 23/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import Haneke
import Reusable

typealias PostCommentPresentable = DateTimePresentable & UserPresentable & TextPresentable

class PostCommentTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var userAvatarImageView: CircleImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layoutMargins = UIEdgeInsets.zero
    
    userAvatarImageView.image = EmptyStateHelper.avatarPlaceholderImage
  }
  
  func configureWith(_ viewModel: PostCommentPresentable) {
    if let avatarURL = viewModel.avatarURL {
      userAvatarImageView.hnk_setImageFromURL(avatarURL)
    }
    
    usernameLabel.text = viewModel.name
    contentLabel.text = viewModel.text
    dateLabel.text = viewModel.dateString
    
    usernameLabel.textColor = UIColor.graySecondaryColor()
  }
}
