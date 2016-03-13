//
//  PhoneVerificationTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 14/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneVerificationTableViewController: UITableViewController {
  
  var sessionData: LoginSessionData!
  
  @IBOutlet weak var verificationCodeTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let submitButton = UIBarButtonItem(title: "Продолжить",
      style: .Done,
      target: self,
      action: "submitButtonAction"
    )
    
    navigationItem.rightBarButtonItem = submitButton
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
  }
  
  override func viewDidAppear(animated: Bool) {
    verificationCodeTextField.becomeFirstResponder()
  }
  
  //MARK: - Actions
  
  func submitButtonAction() {
    guard let code = verificationCodeTextField.text where code != "" else {
      presentAlertWithMessage("Код не может быть пустым")
      return
    }
    
    let serverManager = ServerManager.sharedManager
    serverManager.verifyPhoneNumber(sessionData.phoneNumber,
        withCode: code, andToken: sessionData.verificationToken) { response in
          
      switch response.result {
      case .Success(let userExists):
        if userExists {
          let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
          if let initialViewController = mainStoryboard.instantiateInitialViewController() {
            self.presentViewController(initialViewController, animated: true, completion: nil)
          }
        } else {
          self.performSegueWithIdentifier("registerNewUser", sender: nil)
        }
      case .Failure(let error):
        print(error)
        //TODO: specify error messages
        self.presentAlertWithTitle("Ошибка", andMessage: "Что-то не так с интернетом")
      }
    }
  }
  
  //MARK: - Navigtion
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? NewUserTableViewController {
      destination.sessionData = sessionData
    }
  }
}