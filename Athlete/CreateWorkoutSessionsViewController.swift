//
//  CreateWorkoutSessionsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 25/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class CreateWorkoutSessionsViewController: UIViewController {
  
  var workout: Workout!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func closeButtonAction(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
