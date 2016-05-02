//
//  Program.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Program: Object {
  
  enum Type: String {
    case Running = "running"
    case Cardio = "cardio"
  }
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var programDescription: String = ""
  dynamic var bannerURLString: String = ""
  dynamic var trainer: Trainer?
  dynamic var typeValue: String = Type.Cardio.rawValue
  
  var type: Type {
    get {
      return Type(rawValue: typeValue)!
    }
    set(newType) {
      typeValue = newType.rawValue
    }
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}