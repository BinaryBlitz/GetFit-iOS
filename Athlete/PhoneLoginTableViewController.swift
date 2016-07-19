//
//  PhoneLoginTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SwiftyJSON
import Moya

class PhoneLoginTableViewController: UITableViewController {

  let loginProvider = APIProvider<GetFit.Login>()
  
  @IBOutlet weak var phoneNumberTextField: PhoneNumberTextField!
  @IBOutlet weak var getCodeButton: UIButton!
  
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
      
      GetFit.Login.currentSessionData = LoginSessionData(phoneNumber: phoneNumber)
      loginProvider.request(GetFit.Login.Phone(phone: phoneNumber)) { result in
        switch result {
        case .Success(let response):
          do {
            try response.filterSuccessfulStatusCodes()
            let json = try JSON(response.mapJSON())
            guard let token = json["token"].string else {
              throw Error.JSONMapping(response)
            }
            
            GetFit.Login.currentSessionData?.verificationToken = token
            self.performSegueWithIdentifier("verifyPhoneWithCode", sender: nil)
          } catch {
            self.presentAlertWithTitle("Error", andMessage: "Something was broken")
          }
        case .Failure(let error):
          print(error)
          self.presentAlertWithTitle("Error", andMessage: "Check your internet connection")
        }
        self.getCodeButton.userInteractionEnabled = true
      }
    } catch let error {
      print(error)
      presentAlertWithMessage("Invalid phone number")
      getCodeButton.userInteractionEnabled = true
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? PhoneVerificationTableViewController {
      destination.loginProvider = loginProvider
    }
  }
}
