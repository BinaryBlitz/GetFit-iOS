//
//  SettingsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 07/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  @IBOutlet weak var firstNameLabel: UITextField!
  @IBOutlet weak var lastNameLabel: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstNameLabel.placeholder = "First name"
    lastNameLabel.placeholder = "Last name"
    if let user = UserManger.currentUser {
      firstNameLabel.text = user.firstName
      lastNameLabel.text = user.lastName
    }
  }
  
  //MARK: - Actions
  
  @IBAction func saveButtonAction(sender: AnyObject) {
    guard let firstName = firstNameLabel.text, lastName = lastNameLabel.text else {
      return
    }
    
    if firstName == "" {
      presentAlertWithMessage("First name cannot be blank")
      return
    }
    
    if lastName == "" {
      presentAlertWithMessage("Last name cannot be blank")
      return
    }
    
    if let user = UserManger.currentUser
        where user.firstName != firstName || user.lastName != lastName {
      ServerManager.sharedManager.updateUser(firstName, lastName: lastName) { response in
        switch response.result {
        case .Success(let result):
          print(result)
          self.presentAlertWithMessage("Yay! Your profile is updated!")
          if let user = UserManger.currentUser {
            user.firstName = firstName
            user.lastName = lastName
            UserManger.currentUser = user
          }
          self.view.endEditing(true)
        case .Failure(let error):
          self.presentAlertWithMessage("error: \(error)")
        }
      }
    }
  }
  
  @IBAction func logoutButtonAction(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    let loginViewController = storyboard.instantiateInitialViewController()!
    ServerManager.sharedManager.apiToken = nil
    LocalStorageHelper.save(nil, forKey: .ApiToken)
    presentViewController(loginViewController, animated: true, completion: nil)
  }
  
}
