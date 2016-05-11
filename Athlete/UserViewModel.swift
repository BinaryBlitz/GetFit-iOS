//
//  UserViewModel.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 11/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

struct UserViewModel {
  let user: User
}

extension UserViewModel: UserPresentable {
  
  var name: String {
    return user.name
  }
  
  var info: String {
    return user.description
  }
  
  var avatarURL: NSURL? {
    guard let urlString = user.avatarURLString else { return nil }
    return NSURL(string: urlString)
  }
  
  var coverImageURL: NSURL? {
    guard let urlString = user.bannerURLString else { return nil }
    return NSURL(string: urlString)
  }
}