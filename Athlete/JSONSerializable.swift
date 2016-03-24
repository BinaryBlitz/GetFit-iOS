//
//  JSONSerializable.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 24/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import SwiftyJSON

protocol JSONSerializable {
  init?(json: JSON)
  func convertToJSON() -> JSON
}

extension JSONSerializable {
  
  func convertToJSON() -> JSON {
    return JSON(nilLiteral: ())
  }
}