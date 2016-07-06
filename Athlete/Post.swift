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
import SwiftDate

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
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    guard let id = json["id"].int, content = json["content"].string, createdAt = json["created_at"].string else {
      return nil
    }
    
    self.id = id
    self.content = content
    self.dateCreated = createdAt.toDate(.ISO8601Format(.Extended)) ?? NSDate()
    
    if let likesCount = json["likes_count"].int {
      self.likesCount = likesCount
    }
    
    if let likeId = json["like_id"].int {
      self.likeId = likeId
    }
    
    if let url = json["image_url"].string {
      self.imageURLString = url
    }
    
    if let trainer = Trainer(json: json["trainer"]) {
      self.trainer = trainer
      let realm = try! Realm()
      try! realm.write {
        realm.add(trainer, update: true)
      }
    }
    
    let program = Program()
    program.name = "awesome program"
    program.price = 100
    program.type = "Cardio"
    program.workoutsCount = 10
    self.program = program
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
