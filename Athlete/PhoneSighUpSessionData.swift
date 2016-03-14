//
//  PhoneSighUpSessionData.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 14/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import PhoneNumberKit

struct PhoneSighUpSessionData {
  let phoneNumber: PhoneNumber
  let verificationToken: String
  var name: String?
  
  init(phoneNumber: PhoneNumber, verificationToken: String) {
    self.phoneNumber = phoneNumber
    self.verificationToken = verificationToken
  }
}
