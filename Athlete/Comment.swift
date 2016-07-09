//
//  Comment.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 23/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

class Comment: Object, JSONSerializable {
  
  dynamic var id: Int = 0
  dynamic var author: User?
  dynamic var content: String = ""
  dynamic var dateCreated: NSDate = NSDate()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    guard let id = json["id"].int, content = json["content"].string, dateCreatedString = json["created_at"].string else {
      return nil
    }
    
    self.id = id
    self.content = content
    self.dateCreated = dateCreatedString.toDate(.ISO8601Format(.Extended)) ?? NSDate()
    if let author = User(jsonData: json["author"]) {
      self.author = author
      let realm = try! Realm()
      try! realm.write {
        realm.add(author, update: true)
      }
    }
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}
