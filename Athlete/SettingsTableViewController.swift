//
//  SettingsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 07/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

  override func viewDidLoad() {
      super.viewDidLoad()

  }
  
  @IBAction func logoutButtonAction(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    let loginViewController = storyboard.instantiateInitialViewController()!
    ServerManager.sharedManager.apiToken = nil
    LocalStorageHelper.save(nil, forKey: .ApiToken)
    presentViewController(loginViewController, animated: true, completion: nil)
  }
  
}
