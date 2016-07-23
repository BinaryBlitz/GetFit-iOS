//
//  PhoneVerificationTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 14/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftyJSON

class PhoneVerificationTableViewController: UITableViewController {
  
  var loginProvider: APIProvider<GetFit.Login>!
  
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var verificationCodeTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    submitButton.backgroundColor = UIColor.blueAccentColor()
    submitButton.addTarget(self, action: #selector(self.submitButtonAction), forControlEvents: .TouchUpInside)
    submitButton.setTitle("Подтвердить", forState: .Normal)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    verificationCodeTextField.becomeFirstResponder()
  }
  
  override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard let sessionData = GetFit.Login.currentSessionData, phoneNumber = sessionData.phoneNumber else { return nil }
    return "На номер \(phoneNumber.toInternational()) должно прийти СМС сообщение с кодом подтверждения."
  }
  
  //MARK: - Actions
  
  func submitButtonAction() {
    guard let code = verificationCodeTextField.text where code != "" else {
      presentAlertWithMessage("Код не может быть пустым")
      return
    }
    
    loginProvider.request(GetFit.Login.ConfirmPhoneNumber(code: code)) { result in
      switch result {
      case .Success(let response):
        
        do {
          try response.filterSuccessfulStatusCodes()
          let json = try JSON(response.mapJSON())
          if let apiToken = json["api_token"].string {
            UserManager.apiToken = apiToken
            LocalStorageHelper.save(apiToken, forKey: .ApiToken)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let initialViewController = mainStoryboard.instantiateInitialViewController() {
              self.presentViewController(initialViewController, animated: true, completion: nil)
            }
          } else {
            self.performSegueWithIdentifier("registerNewUser", sender: nil)
          }
        } catch let error {
          print(error)
          self.presentAlertWithTitle("Error", andMessage: "Something was broken")
        }
      case .Failure(let error):
        print(error)
        self.presentAlertWithTitle("Error", andMessage: "Check your internet connection")
      }
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "registerNewUser" {
      let newUserController = segue.destinationViewController as! NewUserViewController
      newUserController.loginProvider = loginProvider
    }
  }
  
}