//
//  User.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

class User: Object, JSONSerializable {
  
  enum Gender: String {
    case Male = "male"
    case Female = "female"
  }
  
  dynamic var id: Int = 0
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var genderValue: String = ""
  dynamic var birthdate: NSDate = NSDate()
  dynamic var userDescription: String?
  dynamic var avatarURLString: String?
  dynamic var bannerURLString: String?
  
  // Statistics
  dynamic var totalWorkouts: Int = 0
  dynamic var totalDuration: Int = 0
  dynamic var totalDistance: Int = 0
  
  var name: String{
    return "\(firstName) \(lastName)"
  }
  
  var gender: Gender? {
    get {
      return Gender(rawValue: genderValue)
    }
    set(newGender) {
      genderValue = newGender?.rawValue ?? ""
    }
  }
  
  var comments: [Comment] {
    return linkingObjects(Comment.self, forProperty: "author")
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init() {
    super.init()
  }
  
  override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    if let id = json["id"].int, firstName = json["first_name"].string, lastName = json["last_name"].string {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
    } else {
      return nil
    }
    
    if let genderValue = json["gender"].string {
      self.genderValue = genderValue
    }
    
    if let avatarURLString = json["avatar_url"].string {
      self.avatarURLString = avatarURLString
    }
    
    if let bannerURLString = json["banner_url"].string {
      self.bannerURLString = bannerURLString
    }
  }
}