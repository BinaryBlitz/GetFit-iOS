//
//  NumberFormatter.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 22/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

class NumberFormatter{
  
  static func stringFromNumber(number: Int) -> String {
    if number >= 1000000 {
      return "\(number / 1000000)m"
    } else if number >= 5000 {
      return "\(number / 1000)k"
    } else {
      return "\(number)"
    }
  }
}