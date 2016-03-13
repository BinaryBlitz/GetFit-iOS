//
//  PhoneLoginTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class PhoneLoginTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIView.animateWithDuration(0.15) {
      self.navigationController?.navigationBarHidden = false
    }
  }
}
