//
//  ProfileCardTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 25/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import Haneke
import Reusable

class ProfileCardTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var avatarImageView: CircleImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
    avatarImageView.layer.borderWidth = 5
    
    bannerImageView.hnk_setImageFromURL(NSURL(string: "https://pbs.twimg.com/media/Cbvs8PvWAAAmYYR.jpg")!)
  }
}
