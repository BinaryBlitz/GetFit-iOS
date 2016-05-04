//
//  ExerciseSession.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 05/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class ExerciseSession: Object {
  
  dynamic var id: Int = 0
  dynamic var exercise: Exercise?
  
  dynamic var completed: Bool = false
  dynamic var reps: Int = 0
  dynamic var distance: Int = 0
  dynamic var sets: Int = 0
  dynamic var weight: Int = 0
  
  override static func primaryKey() -> String? {
    return "id"
  }
}