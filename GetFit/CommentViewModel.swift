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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    return dateFormatter.string(from: comment.dateCreated as Date)
  }
}

//MARK: - UserPresentable

extension CommentViewModel: UserPresentable {
  var name: String {
    guard let author = comment.author else { return "" }
    return "\(author.firstName) \(author.lastName)"
  }
  
  var info: String {
    return ""
  }
  
  var avatarURL: URL? {
    guard let avatarURLString = comment.author?.avatarURLString,
        let avatarURL = URL(string: avatarURLString) else {
      return nil
    }
    
    return avatarURL
  }
  
  var coverImageURL: URL? {
    return nil
  }
}