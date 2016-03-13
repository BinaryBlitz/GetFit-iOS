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
  
  var sessionData: LoginSessionData!

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
    presentAlertWithMessage("Hello, \(firstNameTextField.text)!")
  }
}