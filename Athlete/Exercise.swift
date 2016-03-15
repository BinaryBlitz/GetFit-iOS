//
//  Exercise.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 29/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Exercise: Object {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var exerciseTypeId: Int = 0
  dynamic var repetitions: Int = 0
  dynamic var sets: Int = 0
  dynamic var weight: Double = 0
  dynamic var distance: Int = 0
  dynamic var finished: Bool = false
  
  init(name: String, repetitions: Int, weight: Double? = nil) {
    self.name = name
    self.repetitions = repetitions
    self.weight = weight ?? 0
    super.init()
  }

  required init() {
    super.init()
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}