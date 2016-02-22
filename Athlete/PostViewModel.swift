//
//  PostViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 22/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

//typealias PostPresentable = protocol<TextPresentable, ImagePresentable, TrainerPresentable, DateTimePresentable>

class PostViewModel {
  
  let post: Post
  
  init(post: Post) {
    self.post = post
  }
}

extension PostViewModel: TextPresentable {
  var text: String {
    return post.content
  }
}

extension PostViewModel: ImagePresentable {
  var imageURL: NSURL? {
    guard let imageURLString = post.imageURLString,
        url = NSURL(string: imageURLString) else {
      return nil
    }
    
    return url
  }
}

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

extension PostViewModel: DateTimePresentable {
  var dateString: String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    return dateFormatter.stringFromDate(post.dateCreated)
  }
}