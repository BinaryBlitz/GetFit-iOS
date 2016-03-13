//
//  PhoneLoginTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit

struct LoginSessionData {
  let phoneNumber: PhoneNumber
  let verificationToken: String
}

class PhoneLoginTableViewController: UITableViewController {

  @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
  
  var sessionData: LoginSessionData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showNavigationBar()
    setUpPhoneNumberTextField()
    setUpNavigationBarButtons()
  }
  
  override func viewDidAppear(animated: Bool) {
    phoneNumberTextField.becomeFirstResponder()
  }
  
  private func showNavigationBar() {
    UIView.animateWithDuration(0.15) {
      self.navigationController?.navigationBarHidden = false
    }
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
  }
  
  private func setUpPhoneNumberTextField() {
    phoneNumberTextField.placeholder = "8 926 123-45-67"
    phoneNumberTextField.region = "RU"
  }
  
  private func setUpNavigationBarButtons() {
    let getCodeButton = UIBarButtonItem(title: "Получить код",
      style: .Done,
      target: self,
      action: "getCodeButtonAction"
    )
    
    navigationItem.rightBarButtonItem = getCodeButton
  }
  
  //MARK: - Actions
  
  func getCodeButtonAction() {
    guard let phone = phoneNumberTextField.text where phone != "" else {
      presentAlertWithMessage("Номер телефона не может быть пустым!")
      return
    }
    
    do {
      let phoneNumber = try PhoneNumber(rawNumber: phone, region: "RU")
      print(phoneNumber.toE164())
      
      let serverManager = ServerManager.sharedManager
      
      serverManager.createVerificationTokenFor(phoneNumber) { response in
        switch response.result {
        case .Success(let token):
          self.sessionData = LoginSessionData(phoneNumber: phoneNumber, verificationToken: token)
          self.performSegueWithIdentifier("verifyPhoneWithCode", sender: nil)
        case .Failure(let error):
          print(error)
          //TODO: specify error messages
          self.presentAlertWithTitle("Ошибка", andMessage: "Что-то не так с интернетом")
        }
      }
    } catch {
      presentAlertWithMessage("Номер введен некорректно")
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? PhoneVerificationTableViewController {
      destination.sessionData = sessionData
    }
  }
}
