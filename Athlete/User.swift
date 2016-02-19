//
//  User.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class User: Object {
  
  enum Gender: String {
    case Male = "male"
    case Female = "female"
  }
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var genderValue: String = Gender.Male.rawValue
  dynamic var birthdate: NSDate = NSDate()
  dynamic var desctiption: String?
  dynamic var avatarURLString: String?
  
  var gender: Gender {
    get {
      return Gender(rawValue: genderValue)!
    }
    set(newGender) {
      genderValue = newGender.rawValue
    }
  }

  required init() {
    super.init()
  }
  
  init(id: Int, name: String, gender: Gender) {
    super.init()
    self.id = id
    self.name = name
    self.genderValue = gender.rawValue
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
}