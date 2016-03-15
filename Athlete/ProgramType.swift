//
//  ProgramType.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class ProgramType: Object {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
}