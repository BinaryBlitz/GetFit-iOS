//
//  UIColor+Athlete.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1) {
    self.init(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: alpha)
  }
  
  static func primaryYellowColor() -> UIColor {
    return UIColor(r: 255, g: 208, b: 11)
  }
  
  static func blueAccentColor() -> UIColor {
    return UIColor(r: 34, g: 165, b: 244)
  }
  
  static func greenAccentColor() -> UIColor {
    return UIColor(r: 13, g: 157, b: 87)
  }
  
  static func tabBarSelectedColor() -> UIColor {
    return UIColor(r: 23, g: 24, b: 26)
  }
  
  static func tabBarBackgroundColor() -> UIColor {
    return UIColor(r: 44, g: 45, b: 48)
  }
  
  static func graySecondaryColor() -> UIColor {
    return UIColor(r: 144, g: 150, b: 158)
  }
  
  static func blackTextColor() -> UIColor {
    return UIColor(r: 36, g: 42, b: 52)
  }
  
  static func lightGrayBackgroundColor() -> UIColor {
    return UIColor(white: 0.96, alpha: 1)
  }
  
  static func incomingMessageColor() -> UIColor {
    return UIColor(white: 0.87, alpha: 1)
  }
}
