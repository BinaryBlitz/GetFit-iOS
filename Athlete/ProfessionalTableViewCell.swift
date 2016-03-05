//
//  ProfessionalTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 05/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class ProfessionalTableViewCell: UITableViewCell {

  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var programsBadge: BadgeView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var avatarImageView: CircleImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(trainer: Trainer) {
    nameLabel.text = "\(trainer.firstName) \(trainer.lastName)"
    programsBadge.text = "10 programs".uppercaseString
  }
}
