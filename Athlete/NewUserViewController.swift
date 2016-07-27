//
//  NewUserViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 14/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftyJSON
import Moya

class NewUserViewController: UITableViewController {
  
  var loginProvider: APIProvider<GetFit.Login>!

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var doneButton: UIButton!
  
  var request: Cancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    doneButton.setTitle("OK", forState: UIControlState.Normal)
    doneButton.addTarget(self, action: #selector(self.doneButtonAction), forControlEvents: .TouchUpInside)
    doneButton.backgroundColor = UIColor.blueAccentColor()
    
    firstNameTextField.placeholder = "Имя"
    lastNameTextField.placeholder = "Фамилия"
    
    navigationItem.title = "Новый пользователь"
  }
  
  override func viewDidAppear(animated: Bool) {
    firstNameTextField.becomeFirstResponder()
  }
  
  //MARK: - Actions
  
  func doneButtonAction() {
    
    if let request = request {
      request.cancel()
    }
    
    guard let firstName = firstNameTextField.text where firstName != "" else {
      presentAlertWithMessage("Укажите ваше имя")
      firstNameTextField.becomeFirstResponder()
      return
    }
    
    guard let lastName = lastNameTextField.text where lastName != "" else {
      presentAlertWithMessage("Укажите вашу фамилию")
      lastNameTextField.becomeFirstResponder()
      return
    }
    
    loginProvider.request(.CreateUser(firstName: firstName, lastName: lastName)) { result in
      switch result {
      case .Success(let response):
        
        do {
          try response.filterSuccessfulStatusCodes()
          let json = try JSON(response.mapJSON())
          guard let apiToken = json["api_token"].string else  { throw Error.JSONMapping(response) }
          UserManager.apiToken = apiToken
          LocalStorageHelper.save(apiToken, forKey: .ApiToken)
        
//          let user = try response.mapObject(User.self)
          registerForPushNotifications()
          let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
          if let initialViewController = mainStoryboard.instantiateInitialViewController() {
            self.presentViewController(initialViewController, animated: true, completion: nil)
          }
        } catch {
          self.presentAlertWithTitle("Error", andMessage: "Something was broken")
        }
      case .Failure(let error):
        print(error)
        self.presentAlertWithTitle("Error", andMessage: "Check your internet connection")
      }
    }
  }
  
}