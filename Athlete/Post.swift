//
//  Post.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Post: Object {

  dynamic var id: Int = 0
  dynamic var content: String = ""
  dynamic var trainer: Trainer?
  dynamic var program: Program?
  dynamic var imageURLString: String?
  dynamic var dateCreated: NSDate = NSDate()
  dynamic var likesCount: Int = 0
  dynamic var commentsCount: Int = 0
  
  var comments: [Comment] {
    return linkingObjects(Comment.self, forProperty: "post")
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
