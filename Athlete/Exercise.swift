//
//  Exercise.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 18/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

class Exercise: Object, JSONSerializable {
  
  dynamic var name: String = ""
  
  required init() {
    super.init()
  }
  
  override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    guard let name = json["exercise_type"]["name"].string else {
      return nil
    }
    
    self.name = name
  }
}