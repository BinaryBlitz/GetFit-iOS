//
//  PostTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Haneke
import PureLayout
import Reusable

typealias PostCellPresentable = protocol<PostPresentable, TrainerPresentable, DateTimePresentable, TextPresentable>

class PostTableViewCell: UITableViewCell, NibReusable {
  
  //MARK: - Constants
  private let contentHeight: CGFloat = 208
  private let spaceBetweenTextAndContent: CGFloat = 12
  private let numberOfLinesInPostPreview = 5

  //MARK: - Base
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
  
  enum PostCellState {
    case Normal
    case Card
  }
  
  var state: PostCellState = .Card {
    didSet {
      updateWithState(state)
    }
  }
  
  var liked: Bool {
    get {
      return likeButton.selected
    }
    set(newValue) {
      likeButton.selected = newValue
    }
  }
  
  //MARK: - Delegate
  
  weak var delegate: PostTableViewCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    contentView.backgroundColor = .lightGrayBackgroundColor()
    
    likeButton.setImage(UIImage(named: "Likes"), forState: .Normal)
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: .Selected)
    likeButton.setImage(UIImage(named: "LikesSelected"), forState: .Highlighted)
    
    trainerNameLabel.textColor = UIColor.graySecondaryColor()
  }
  
  //MARK: - Cell configuration
  
  func configureWith(viewModel: PostCellPresentable) {
    if let imageURL = viewModel.imageURL {
      updateContentWith(.Photo(photoURL: imageURL))
    } else if let program = viewModel.program {
      updateContentWith(.TrainingProgram(program: program))
    } else {
      updateContentWith(.None)
    }
    
    postContentLabel.text = viewModel.text
    
    if let trainerAvatarURL = viewModel.trainerAvatarURL {
      trainerAvatarImageView.hnk_setImageFromURL(trainerAvatarURL)
    }
    
    likeButton.selected = viewModel.liked
    trainerNameLabel.text = viewModel.trainerName
    
    dateView.text = viewModel.dateString
    
    likesCountLabel.text = viewModel.likesCount
    commentsCountLabel.text = viewModel.commentsCount
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
      containerView.addSubview(imageView)
      imageView.autoPinEdgesToSuperviewEdges()
    case .TrainingProgram(let program):
      containerHeight.constant = contentHeight
      containerToTextSpace.constant = spaceBetweenTextAndContent
      containerView.hidden = false
      containerView.backgroundColor = UIColor.lightGrayColor()
      let programView = NSBundle.mainBundle().loadNibNamed(String(ProgramTableViewCell), owner: self, options: nil).first as! ProgramTableViewCell
      programView.state = .Normal
      programView.configureWith(ProgramViewModel(program: program))
      programView.hideBanner()
      containerView.addSubview(programView)
      programView.autoPinEdgesToSuperviewEdges()
    }
  }
  
  //MARK: - Actions
  
  @IBAction func commentButtonAction(sender: AnyObject) {
    delegate?.didTouchCommentButton(self)
  }
  
  @IBAction func likeButtonAction(sender: AnyObject) {
    defer { delegate?.didTouchLikeButton(self) }
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
  
  private func updateWithState(state: PostCellState) {
    switch state {
    case .Card:
      cardView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    case .Normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}

//MARK: - Previewable

extension PostTableViewCell: Previewable {
  var displayAsPreview: Bool {
    get {
      return postContentLabel.numberOfLines != 0
    }
    set {
      postContentLabel.numberOfLines = newValue ? numberOfLinesInPostPreview : 0
    }
  }
}
