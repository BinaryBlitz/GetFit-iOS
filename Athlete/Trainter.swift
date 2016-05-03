//
//  Trainter.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Trainer: Object {
  
  dynamic var id: Int = 0
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var email: String = ""
  dynamic var categoryValue: String = TrainerCategory.Coach.rawValue
  dynamic var avatarURLString: String = ""
  dynamic var bannerURLString: String = ""
  
  var category: TrainerCategory {
    get {
      return TrainerCategory(rawValue: categoryValue)!
    }
    set(newCategory) {
      categoryValue = newCategory.rawValue
    }
  }
  
  var posts: [Post] {
    return linkingObjects(Post.self, forProperty: "trainer")
  }
  
  var programs: [Program] {
    return linkingObjects(Program.self, forProperty: "trainer")
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}