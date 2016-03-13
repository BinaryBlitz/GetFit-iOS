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
    self.presentAlertWithMessage("yo")
  }
}
