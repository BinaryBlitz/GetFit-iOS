//
//  PhoneNumberTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneNumberTableViewCell: UITableViewCell {

  @IBOutlet weak var phoneNumberField: PhoneNumberTextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    phoneNumberField.placeholder = "8 926 123-45-67"
    phoneNumberField.region = "RU"
  }
}
