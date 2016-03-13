//
//  PhoneLoginTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneLoginTableViewController: UITableViewController {

  @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIView.animateWithDuration(0.15) {
      self.navigationController?.navigationBarHidden = false
    }
    
    phoneNumberTextField.placeholder = "8 926 123-45-67"
    phoneNumberTextField.region = "RU"
  }
}
