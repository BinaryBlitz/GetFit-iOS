//
//  Trainter.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate

class Trainer: Object, JSONSerializable {
  
  dynamic var id: Int = 0
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var info: String = ""
  dynamic var email: String = ""
  dynamic var categoryValue: String = TrainerCategory.Coach.rawValue
  dynamic var avatarURLPath: String? = ""
  dynamic var bannerURLPath: String? = ""
  dynamic var programsCount: Int = 0
  dynamic var followersCount: Int = 0
  
  var bannerURLString: String? {
    guard let imagePath = bannerURLPath else { return nil }
    return ServerManager.sharedManager.baseURL + imagePath
  }
  
  var avatarURLString: String? {
    guard let imagePath = avatarURLPath else { return nil }
    return ServerManager.sharedManager.baseURL + imagePath
  }
  
  var category: TrainerCategory {
    get {
      return TrainerCategory(rawValue: categoryValue)!
    }
    set(newCategory) {
      categoryValue = newCategory.rawValue
    }
  }
  
  let posts = LinkingObjects(fromType: Post.self, property: "trainer")
  
  let programs = LinkingObjects(fromType: Program.self, property: "trainer")
  
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
    
    guard let id = json["id"].int, firstName = json["first_name"].string, lastName = json["last_name"].string else {
      return nil
    }
    
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    
    if let description = json["description"].string {
      self.info = description
    }
    
    if let avatarURLPath = json["avatar_url"].string {
      self.avatarURLPath = avatarURLPath
    }
    
    if let bannerURLPath = json["banner_url"].string {
      self.bannerURLPath = bannerURLPath
    }
    
    if let followersCount = json["followers_count"].int {
      self.followersCount = followersCount
    }
    
    if let programsCount = json["programs_count"].int {
     self.programsCount = programsCount
    }
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}