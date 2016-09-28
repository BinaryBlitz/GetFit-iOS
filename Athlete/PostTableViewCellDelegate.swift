//
//  PostTableViewCellDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 24/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol PostTableViewCellDelegate: class {
  func didTouchLikeButton(_ cell: PostTableViewCell)
  func didTouchCommentButton(_ cell: PostTableViewCell)
}

extension PostTableViewCellDelegate {
  
  func didTouchLikeButton(_ cell: PostTableViewCell) {
    print("like button")
  }
  
  func didTouchCommentButton(_ cell: PostTableViewCell) {
    print("comment button")
  }
}

