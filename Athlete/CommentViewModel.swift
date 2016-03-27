//
//  CommentViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 23/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

struct CommentViewModel {
  let comment: Comment
}

//MARK: - TextPresentable

extension CommentViewModel: TextPresentable {
  var text: String {
    return comment.content
  }
}

//MARK: - DateTimePresentable

extension CommentViewModel: DateTimePresentable {
  var dateString: String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    return dateFormatter.stringFromDate(comment.dateCreated)
  }
}

//MARK: - UserPresentable

extension CommentViewModel: UserPresentable {
  var name: String {
    return comment.author?.name ?? ""
  }
  
  var info: String {
    return ""
  }
  
  var avatarURL: NSURL? {
    guard let avatarURLString = comment.author?.avatarURLString,
        avatarURL = NSURL(string: avatarURLString) else {
      return nil
    }
    
    return avatarURL
  }
  
  var coverImageURL: NSURL? {
    return nil
  }
}