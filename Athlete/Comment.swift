//
//  Comment.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 23/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Comment: Object {
  
  dynamic var id: Int = 0
  dynamic var post: Post?
  dynamic var content: String = ""
  dynamic var author: User?
  dynamic var dateCreated: NSDate = NSDate()
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
