//
//  Training.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

struct Training {
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
  
  init(name: String, type: TrainingType, duration: Int, date: NSDate) {
    self.name = name
    self.type = type
    self.duration = duration
    self.date = date
  }
}
