//
//  ExerciseType.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class ExerciseType: Object {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var exersiceDescription: String = ""
  dynamic var videoURLString: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
}