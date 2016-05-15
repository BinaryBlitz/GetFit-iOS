//
//  Workout.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

class Workout: Object, JSONSerializable {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var duration: Int = 0
  dynamic var programName: String = ""
  dynamic var programId: Int = 0
  dynamic var position: Int = 0
  dynamic var exercisesCount: Int = 0
  
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
    
    guard let id = json["id"].int, name = json["name"].string else {
      return nil
    }
    
    self.id = id
    self.name = name
  }
  
}