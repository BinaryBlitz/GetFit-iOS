//
//  Double+round.swift
//  GetFit
//
//  Created by Алексей on 10.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation

extension Double {
  func round(to places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }

  func roundedString(places: Int = 1, minimumPlaces: Int = 1) -> String {
    let numberFormatter = NumberFormatter()

    numberFormatter.minimumFractionDigits = minimumPlaces
    numberFormatter.decimalSeparator = "."
    numberFormatter.maximumFractionDigits = places
    return numberFormatter.string(from: self as NSNumber) ?? ""
  }
}
