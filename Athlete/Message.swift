//
//  Message.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 02/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

class Message: Object {
  
  dynamic var id: Int = 0
  dynamic var conetnt: String?
  dynamic var imageURLString: String?
  dynamic var dateCreated: NSDate = NSDate()
}
