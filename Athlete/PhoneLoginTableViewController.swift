//
//  PhoneLoginTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit

class PhoneLoginTableViewController: UITableViewController {

  @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
  
  @IBOutlet weak var getCodeButton: UIButton!
  var sessionData: PhoneSighUpSessionData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showNavigationBar()
    setupPhoneNumberTextField()
    getCodeButton.backgroundColor = UIColor.blueAccentColor()
  }
  
  override func viewDidAppear(animated: Bool) {
    phoneNumberTextField.becomeFirstResponder()
  }
  
  private func showNavigationBar() {
    UIView.animateWithDuration(0.15) {
      self.navigationController?.navigationBarHidden = false
    }
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }
  
  private func setupPhoneNumberTextField() {
    phoneNumberTextField.placeholder = "8 926 123-45-67"
    phoneNumberTextField.defaultRegion = "RU"
  }
  
  //MARK: - Actions
  
  @IBAction func getCodeButtonAction() {
    guard let phone = phoneNumberTextField.text where phone != "" else {
      presentAlertWithMessage("Номер телефона не может быть пустым!")
      return
    }
    getCodeButton.userInteractionEnabled = false
    
    do {
      let phoneNumber = try PhoneNumber(rawNumber: phone, region: "RU")
      
      let serverManager = ServerManager.sharedManager
      
      serverManager.createVerificationTokenFor(phoneNumber) { response in
        switch response.result {
        case .Success(let token):
          self.sessionData = PhoneSighUpSessionData(phoneNumber: phoneNumber, verificationToken: token)
          self.performSegueWithIdentifier("verifyPhoneWithCode", sender: nil)
        case .Failure(let error):
          print(error)
          //TODO: specify error messages
          self.presentAlertWithTitle("Ошибка", andMessage: "Что-то не так с интернетом")
        }
        self.getCodeButton.userInteractionEnabled = true
      }
    } catch let error {
      print(error)
      presentAlertWithMessage("Номер введен некорректно")
      getCodeButton.userInteractionEnabled = true
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? PhoneVerificationTableViewController {
      destination.sessionData = sessionData
    }
  }
}
