//
//  PostTableViewCellDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 24/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol PostTableViewCellDelegate: class {
  func didTouchLikeButton(cell: PostTableViewCell)
  func didTouchCommentButton(cell: PostTableViewCell)
}

extension PostTableViewCellDelegate {
  
  func didTouchLikeButton(cell: PostTableViewCell) {
    print("like button")
  }
  
  func didTouchCommentButton(cell: PostTableViewCell) {
    print("comment button")
  }
}

