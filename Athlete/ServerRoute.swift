//
//  ServerRoute.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

enum ServerRoute: String {
  case VerificationTokens = "verification_tokens"
  case User = "user"
  case Users = "users"
  case Posts = "posts"
  case Trainers = "trainers"
  case Statistics = "statistics"
  case Comments = "comments"
  case Programs = "programs"
  case Likes = "likes"
  case FBAuth = "user/authenticate_fb"
  case VKAuth = "user/authenticate_vk"
  
  var path: String {
    return ServerManager.sharedManager.baseAPIURL + rawValue
  }
  
  func pathWith<Value: CustomStringConvertible>(value: Value) -> String {
    return self.path + "/\(value)"
  }
  
  func pathWith(value: String) -> String {
    return self.path + "/\(value)"
  }
}