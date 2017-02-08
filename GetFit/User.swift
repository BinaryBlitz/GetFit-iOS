//
//  User.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import Moya_SwiftyJSONMapper
import SwiftyJSON

class User: Object, ALSwiftyJSONAble {
  
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
  dynamic private(set) var totalWorkouts: Int = 0
  dynamic private(set) var totalDuration: Int = 0
  dynamic private(set) var totalDistance: Int = 0
  
  let comments = LinkingObjects(fromType: Comment.self, property: "author")
  
  var gender: Gender? {
    get {
      return Gender(rawValue: genderValue)
    }
    set(newGender) {
      genderValue = newGender?.rawValue ?? ""
    }
  }
  
  var statistics: Statistics {
    get {
      return Statistics(workouts: totalWorkouts, duration: totalDuration, distance: totalDistance)
    }
    set {
      totalWorkouts = newValue.totalWorkouts
      totalDistance = newValue.totalDistance
      totalDuration = newValue.totalDuration
    }
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(jsonData: JSON) {
    super.init()
    
    if let id = jsonData["id"].int, firstName = jsonData["first_name"].string, lastName = jsonData["last_name"].string {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
    } else {
      return nil
    }
    
    if let genderValue = jsonData["gender"].string {
      self.genderValue = genderValue
    }
    
    if let avatarPath = jsonData["avatar_url"].string {
      self.avatarURLString = avatarPath
    }
    
    if let bannerPath = jsonData["banner_url"].string {
      self.bannerURLString = bannerPath
    }
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}

//MARK: - Statistics

extension User {
  
  struct Statistics: ALSwiftyJSONAble {
    let totalWorkouts: Int
    let totalDuration: Int
    let totalDistance: Int
    
    init(workouts: Int, duration: Int, distance: Int) {
      totalWorkouts = workouts
      totalDuration = duration
      totalDistance = distance
    }
    
    init?(jsonData: JSON) {
      guard let totalWorkouts = jsonData["workouts_count"].int,
          totalDuration = jsonData["total_duration"].int,
          totalDistance = jsonData["total_distance"].int else {
        self.totalWorkouts = 0
        self.totalDuration = 0
        self.totalDistance = 0
        return
      }
      
      self.totalWorkouts = totalWorkouts
      self.totalDuration = totalDuration
      self.totalDistance = totalDistance
    }
  }
  
}