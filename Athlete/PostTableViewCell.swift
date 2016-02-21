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
  @IBOutlet weak var containerHeight: NSLayoutConstraint!
  @IBOutlet weak var containerToTextSpace: NSLayoutConstraint!
  
  //MARK: - Footer
  @IBOutlet weak var dateView: BadgeView!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var likesCountLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  
  enum ContentType {
    case None
    case Photo
    case Program
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: UIControlState.Selected)
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: UIControlState.Highlighted)
    likeButton.setImage(UIImage(named: "Likes"), forState: UIControlState.Normal)
    
    dateView.style = BadgeView.Style.LightGray
    //TODO: add date
    dateView.text = "4/11"
    
    
    updateContentWith(.None)
  }
  
  func updateContentWith(type: ContentType) {
    switch type {
    case .None:
      containerHeight.constant = 0
      containerToTextSpace.constant = 0
      containerView.hidden = true
    case .Photo:
      break
    case .Program:
      break
    }
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
