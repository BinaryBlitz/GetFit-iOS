//
//  Exercise.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 29/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

class Exercise {
  var name: String
  var repetitions: Int
  var weight: Double? = nil
  var finished: Bool = false
  
  init(name: String, repetitions: Int, weight: Double? = nil) {
    self.name = name
    self.repetitions = repetitions
    self.weight = weight
  }
}