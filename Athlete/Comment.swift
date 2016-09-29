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
import Moya_SwiftyJSONMapper

open class Comment: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  dynamic var author: User?
  dynamic var content: String = ""
  dynamic var dateCreated: Date = Date()
  
  override open static func primaryKey() -> String? {
    return "id"
  }
  
  required public init() {
    super.init()
  }
  
  required public init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required public init?(jsonData: JSON) {
    super.init()
    
    guard let id = jsonData["id"].int, let content = jsonData["content"].string, let dateCreatedString = jsonData["created_at"].string else {
      return nil
    }
    
    self.id = id
    self.content = content
    self.dateCreated = dateCreatedString.toDate(format: .iso8601Format(.extended)) ?? Date()
    if let author = User(jsonData: jsonData["author"]) {
      self.author = author
      let realm = try! Realm()
      try! realm.write {
        realm.add(author, update: true)
      }
    }
  }
  
  required public init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}
