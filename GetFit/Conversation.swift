//
//  Conversation.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 02/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import RealmSwift

enum SenderType: String {
  case Trainer = "trainer"
  case User = "user"
  case Notifier = "notifier"
}

class Conversation: Object {
  
  dynamic var id: Int = 0
  dynamic var senderId: Int = 0
  dynamic var senderTypeValue: String = SenderType.Trainer.rawValue
  
  //MARK: - Properties
  
  var senderType: SenderType {
    get {
      return SenderType(rawValue: senderTypeValue)!
    }
    set {
      senderTypeValue = newValue.rawValue
    }
  }
  
  let messages = List<Message>()
}
