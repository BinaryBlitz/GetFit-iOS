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
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    return "Version: \(appVersion) (\(buildVersion))"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstNameLabel.placeholder = "First name"
    lastNameLabel.placeholder = "Last name"
    if let user = UserManager.currentUser {
      firstNameLabel.text = user.firstName
      lastNameLabel.text = user.lastName
    }
    
    let footerView = UIView()
    footerView.backgroundColor = UIColor.clear
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = UIColor.lightGray
    label.text = versionNumber
    footerView.addSubview(label)
    label.autoCenterInSuperview()
    
    tableView.tableFooterView = footerView
  }
  
  //MARK: - Actions
  
  @IBAction func saveButtonAction(_ sender: AnyObject) {
    guard let firstName = firstNameLabel.text, let lastName = lastNameLabel.text else {
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
    
    if let user = UserManager.currentUser, user.firstName != firstName || user.lastName != lastName {
      
      userProvider.request(.update(firstName: firstName, lastName: lastName)) { result in
        switch result {
        case .success(let response):
          do {
            try _ = response.filterSuccessfulStatusCodes()
            self.view.endEditing(true)
            self.presentAlertWithMessage("Yay! Your profile is updated!")
            if let user = UserManager.currentUser {
              user.firstName = firstName
              user.lastName = lastName
              UserManager.currentUser = user
            }
          } catch {
            self.view.endEditing(true)
            self.presentAlertWithMessage("Error with code \(response.statusCode)")
          }
        case .failure(let error):
          self.presentAlertWithMessage("error: \(error)")
        }
      }
      
    }
  }
  
  @IBAction func logoutButtonAction(_ sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Login", bundle: nil)
    let loginViewController = storyboard.instantiateInitialViewController()!
    UserManager.apiToken = nil
    LocalStorageHelper.save(nil, forKey: .apiToken)
    present(loginViewController, animated: true, completion: nil)
  }
  
}