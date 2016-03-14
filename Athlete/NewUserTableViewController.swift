//
//  NewUserTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 14/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit

class NewUserTableViewController: UITableViewController {
  
  var sessionData: PhoneSighUpSessionData!

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let doneButton = UIBarButtonItem(title: "ОК", style: .Done, target: self, action: "doneButtonAction")
    navigationItem.rightBarButtonItem = doneButton
    
    navigationItem.title = "Новый пользователь"
  }
  
  //MARK: - Actions
  
  func doneButtonAction() {
    guard let firstName = firstNameTextField.text, lastName = lastNameTextField.text
          where firstName != "" && lastName != "" else {
            
      presentAlertWithMessage("Oops! Имя не может быть пустым!")
      return
    }
    
    let serverManager = ServerManager.sharedManager
    
    sessionData.name = "\(firstName) \(lastName)"
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
        self.presentAlertWithMessage("Ого! Что-то сломалось")
      }
    }
  }
}