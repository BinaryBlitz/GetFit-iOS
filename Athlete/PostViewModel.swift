//
//  PostViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 22/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

struct PostViewModel {
  let post: Post
}

//MARK: - PostPresentable

extension PostViewModel: PostPresentable {
  var imageURL: URL? {
    guard let imageURLString = post.imageURLString,
        let url = URL(string: imageURLString) else {
      return nil
    }
    
    return url
  }
  
  var likesCount: String {
    return post.likesCount.format()
  }
  
  var commentsCount: String {
    return post.commentsCount.format()
  }
  
  var liked: Bool {
    return post.likeId != -1
  }
  
  var program: Program? {
    return post.program
  }
}

//MARK: - TextPresentable

extension PostViewModel: TextPresentable {
  var text: String {
    return post.content
  }
}

//MARK: - TrainerPresentable

extension PostViewModel: TrainerPresentable {
  var trainerAvatarURL: URL? {
    guard let trainer = post.trainer,
        let avatarURLString = trainer.avatarURLString else {
      return nil
    }
    
    return URL(string: avatarURLString)
  }
  
  var trainerName: String {
    guard let trainer = post.trainer else {
      return ""
    }
    
    return "\(trainer.firstName) \(trainer.lastName)"
  }
}

//MARK: - DateTimePresentable

extension PostViewModel: DateTimePresentable {
  var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    return dateFormatter.string(from: post.dateCreated as Date)
  }
}
