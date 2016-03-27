//
//  Training.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation

class Training {
  enum TrainingType: String {
    case Cardio
    case Running
    case Football
    case Basketball
  }
  
  var name: String
  var type: TrainingType
  var duration: Int
  var date: NSDate
  var exercises = [Exercise]()
  
  init() {
    name = ""
    type = TrainingType.Cardio
    duration = 0
    date = NSDate()
  }
  
  init(name: String, type: TrainingType, duration: Int, date: NSDate) {
    self.name = name
    self.type = type
    self.duration = duration
    self.date = date
  }
}