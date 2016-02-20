//
//  Trainter.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Trainer: Object {
  
  enum Category: String {
    case Coach = "coach"
    case Doctor = "doctor"
    case Nutritionist = "nutritionist"
  }
  
  dynamic var id: Int = 0
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var email: String = ""
  dynamic var categoryValue: String = Category.Coach.rawValue
  dynamic var avatarURLString: String = ""
  dynamic var bannerURLString: String = ""
  
  var category: Category {
    get {
      return Category(rawValue: categoryValue)!
    }
    set(newCategory) {
      categoryValue = newCategory.rawValue
    }
  }
  
  var posts: [Post] {
    return linkingObjects(Post.self, forProperty: "trainer")
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}