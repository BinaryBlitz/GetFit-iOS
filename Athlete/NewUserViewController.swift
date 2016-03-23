//
//  NewUserViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 14/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Eureka
import Alamofire

class NewUserViewController: UITableViewController {
  
  var sessionData: PhoneSighUpSessionData!

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var doneButton: UIButton!
  
  var request: Request?
  
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
    
    sessionData.firstName = firstName
    sessionData.lastName = lastName
    
    //FIXME: tmp data
    sessionData.birthdate = NSDate()
    sessionData.gender = .Male
    sessionData.height = 171
    sessionData.weight = 65
    
    let serverManager = ServerManager.sharedManager
    
    serverManager.createNewUserWithData(sessionData) { response in
      switch response.result {
      case .Success(let user):
        print("User: \(user)")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let initialViewController = mainStoryboard.instantiateInitialViewController() {
          self.presentViewController(initialViewController, animated: true, completion: nil)
        }
      case .Failure(let serverError):
        //TODO: specify server errors
        print(serverError)
        if serverError == .InvalidData {
          let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
          if let initialViewController = mainStoryboard.instantiateInitialViewController() {
            self.presentViewController(initialViewController, animated: true, completion: nil)
          }
        } else {
          self.presentAlertWithMessage("Ого! Что-то сломалось")
        }
      }
    }
  }
}