//
//  WorkoutSession.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate
import Moya_SwiftyJSONMapper

class WorkoutSession: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var duration: Int = 0
  dynamic var programName: String = ""
  dynamic var programId: Int = 0
  dynamic var date: NSDate = NSDate()
  dynamic var position: Int = 0
  dynamic var exercisesCount: Int = 0
  var exercises = List<ExerciseSession>()
  
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
    
    guard let id = jsonData["id"].int, name = jsonData["name"].string else {
      return nil
    }
    
    self.id = id
    self.name = name
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}