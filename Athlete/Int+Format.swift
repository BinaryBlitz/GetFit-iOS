//
//  Int+Format.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 08/07/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

extension Int {
  
  func format() -> String {
    if self >= 1000000 {
      return "\(self / 1000000)m"
    } else if self >= 5000 {
      return "\(self / 1000)k"
    } else {
      return "\(self)"
    }
  }
}