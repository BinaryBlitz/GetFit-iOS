//
//  TrainerCategory.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

enum TrainerCategory: String {
  case Coach = "trainer"
  case Doctor = "physician"
  case Nutritionist = "nutritionist"
  
  func pluralName() -> String {
    switch self {
    case .Coach:
      return "Coaches"
    case .Doctor:
      return "Doctors"
    case .Nutritionist:
      return "Nutritionists"
    }
  }
}
