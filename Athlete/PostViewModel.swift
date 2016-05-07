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
  var imageURL: NSURL? {
    guard let imageURLString = post.imageURLString,
        url = NSURL(string: ServerManager.sharedManager.pathToImage(imageURLString)) else {
      return nil
    }
    
    return url
  }
  
  var likesCount: String {
    return NumberFormatter.stringFromNumber(post.likesCount)
  }
  
  var commentsCount: String {
    return NumberFormatter.stringFromNumber(post.commentsCount)
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
  var trainerAvatarURL: NSURL? {
    guard let trainer = post.trainer,
        url = NSURL(string: trainer.avatarURLString) else {
      return nil
    }
    
    return url
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
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    return dateFormatter.stringFromDate(post.dateCreated)
  }
}