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
  @IBOutlet weak var getCodeButton: ActionButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showNavigationBar()
    setupPhoneNumberTextField()
    getCodeButton.backgroundColor = UIColor.blueAccentColor()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    phoneNumberTextField.becomeFirstResponder()
  }
  
  fileprivate func showNavigationBar() {
    UIView.animate(withDuration: 0.15, animations: {
      self.navigationController?.isNavigationBarHidden = false
    }) 
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  fileprivate func setupPhoneNumberTextField() {
    phoneNumberTextField.placeholder = "8 926 123-45-67"
    phoneNumberTextField.defaultRegion = "RU"
  }
  
  //MARK: - Actions
  
  @IBAction func getCodeButtonAction() {
    guard let phone = phoneNumberTextField.text , phone != "" else {
      presentAlertWithMessage("Номер телефона не может быть пустым!")
      return
    }
    
    getCodeButton.showActivityIndicator()
    do {
      let phoneNumber = try PhoneNumber(rawNumber: phone, region: "RU")
      GetFit.Login.currentSessionData = LoginSessionData(phoneNumber: phoneNumber)
      requestLoginCodeFor(phoneNumber: phoneNumber)
    } catch let error {
      print(error)
      getCodeButton.hideActivityIndicator()
      presentAlertWithMessage("Invalid phone number")
    }
  }
  
  fileprivate func requestLoginCodeFor(phoneNumber: PhoneNumber) {
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
      self.getCodeButton.hideActivityIndicator()
    }
  }
  
  //MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? PhoneVerificationTableViewController {
      destination.loginProvider = loginProvider
    }
  }
}
