//
//  Post.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
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
  dynamic var likeId: Int = -1
  let comments = List<Comment>()
  
  required init() {
    super.init()
  }
  
  override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    guard let id = json["id"].int, content = json["content"].string, createdAt = json["created_at"].string else {
      return nil
    }
    
    self.id = id
    self.content = content
    self.dateCreated = createdAt.toDateFromISO8601() ?? NSDate()
    
    if let likeId = json["like_id"].int {
      self.likeId = likeId
    }
    
    if let url = json["image_url"].string {
      self.imageURLString = url
    }
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
