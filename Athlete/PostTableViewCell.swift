//
//  PostTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

  @IBOutlet weak var cardView: CardView!
  
  //MARK: - Header
  @IBOutlet weak var trainerAvatarImageView: CircleImageView!
  @IBOutlet weak var tainerNameLabel: UILabel!
  
  //MARK: - Body
  @IBOutlet weak var postContentLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
  
  //MARK: - Footer
  @IBOutlet weak var dateView: BadgeView!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var likesCountLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: UIControlState.Selected)
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: UIControlState.Highlighted)
    likeButton.setImage(UIImage(named: "Likes"), forState: UIControlState.Normal)
    
    dateView.style = BadgeView.Style.LightGray
    //TODO: add date
    dateView.text = "4/11"
  }
  
  @IBAction func commentButtonAction(sender: AnyObject) {
    print("comment!")
  }
  
  @IBAction func likeButtonAction(sender: AnyObject) {
    likeButton.selected = !likeButton.selected
    
    if let likesString = likesCountLabel.text,
        likes = Int(likesString) {
      if likeButton.selected {
        likesCountLabel.text = String(likes + 1)
      } else {
        likesCountLabel.text = String(likes - 1)
      }
    }
  }
}
