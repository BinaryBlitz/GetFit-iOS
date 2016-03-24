//
//  Post.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Post: Object, JSONSerializable {

  dynamic var id: Int = 0
  dynamic var content: String = ""
  dynamic var trainer: Trainer?
  dynamic var program: Program?
  dynamic var imageURLString: String?
  dynamic var dateCreated: NSDate = NSDate()
  dynamic var likesCount: Int = 0
  dynamic var commentsCount: Int = 0
  let comments = List<Comment>()
  
  required init() {
    super.init()
  }
  
  //TODO: implement JSONSerializable
  
  required init?(json: JSON) {
    return nil
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
