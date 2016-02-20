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
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
