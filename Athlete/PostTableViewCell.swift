//
//  PostTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Haneke

//TODO: decompose me plz
protocol ImagePresentable {
  var imageURL: NSURL? { get }
}

protocol TrainerPresentable {
  var trainerAvatarURL: NSURL? { get }
  var trainerName: String { get }
}

protocol TextPresentable {
  var text: String { get }
}

protocol DateTimePresentable {
  var dateString: String { get }
}

typealias PostPresentable = protocol<TextPresentable, ImagePresentable, TrainerPresentable, DateTimePresentable>

class PostTableViewCell: UITableViewCell {
  
  private let contentHeight: CGFloat = 208
  private let spaceBetweenTextAndContent: CGFloat = 12

  @IBOutlet weak var cardView: CardView!
  
  //MARK: - Header
  @IBOutlet weak var trainerAvatarImageView: CircleImageView!
  @IBOutlet weak var trainerNameLabel: UILabel!
  
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
    case Photo(photoURL: NSURL)
    case TrainingProgram(program: Program)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = .lightGrayBackgroundColor()
    
    likeButton.setImage(UIImage(named: "Likes"), forState: .Normal)
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: .Selected)
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: .Highlighted)
    
    dateView.style = .LightGray
  }
  
  func configureWith(viewModel: PostPresentable) {
    if let imageURL = viewModel.imageURL {
      updateContentWith(.Photo(photoURL: imageURL))
    } else {
      updateContentWith(.None)
    }
    
    postContentLabel.text = viewModel.text
    
    if let trainerAvatarURL = viewModel.trainerAvatarURL {
      trainerAvatarImageView.hnk_setImageFromURL(trainerAvatarURL)
    }
    
    trainerNameLabel.text = viewModel.trainerName
    
    dateView.text = viewModel.dateString
  }
  
  private func updateContentWith(type: ContentType) {
    switch type {
    case .None:
      containerHeight.constant = 0
      containerToTextSpace.constant = 0
      containerView.hidden = true
    case .Photo(let photoURL):
      containerHeight.constant = contentHeight
      containerToTextSpace.constant = spaceBetweenTextAndContent
      containerView.hidden = false
      containerView.backgroundColor = UIColor.lightGrayColor()
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: contentHeight))
      imageView.contentMode = UIViewContentMode.ScaleAspectFill
      imageView.layer.masksToBounds = true
      imageView.hnk_setImageFromURL(photoURL)
      UIView.addContent(imageView, toView: containerView)
    case .TrainingProgram(_):
      fatalError("Posts with TrainingProgram are no implemented yet")
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
