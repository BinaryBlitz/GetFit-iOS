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
  let userProvider = APIProvider<GetFit.Users>()

  var versionNumber: String {
    let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    let buildVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    return "Version: \(appVersion) (\(buildVersion))"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstNameLabel.placeholder = "First name"
    lastNameLabel.placeholder = "Last name"
    if let user = UserManger.currentUser {
      firstNameLabel.text = user.firstName
      lastNameLabel.text = user.lastName
    }
    
    let footerView = UIView()
    footerView.backgroundColor = UIColor.clearColor()
    let label = UILabel()
    label.font = UIFont.systemFontOfSize(14)
    label.textColor = UIColor.lightGrayColor()
    label.text = versionNumber
    footerView.addSubview(label)
    label.autoCenterInSuperview()
    
    tableView.tableFooterView = footerView
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
      
      userProvider.request(.Update(firstName: firstName, lastName: lastName)) { result in
        switch result {
        case .Success(let response):
          do {
            try response.filterSuccessfulStatusCodes()
            self.view.endEditing(true)
            self.presentAlertWithMessage("Yay! Your profile is updated!")
            if let user = UserManger.currentUser {
              user.firstName = firstName
              user.lastName = lastName
              UserManger.currentUser = user
            }
          } catch {
            self.view.endEditing(true)
            self.presentAlertWithMessage("Error with code \(response.statusCode)")
          }
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
