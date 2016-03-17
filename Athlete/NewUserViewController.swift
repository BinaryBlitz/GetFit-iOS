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

class NewUserViewController: FormViewController {
  
  var sessionData: PhoneSighUpSessionData!

//  @IBOutlet weak var firstNameTextField: UITextField!
//  @IBOutlet weak var lastNameTextField: UITextField!
  
  var request: Request?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let doneButton = UIBarButtonItem(title: "ОК", style: .Done, target: self, action: "doneButtonAction")
    navigationItem.rightBarButtonItem = doneButton
    
    navigationItem.title = "Новый пользователь"
    
    initialiseForm()
  }
  
  //MARK: - Form
  
  func initialiseForm() {
    rowsSetup()
    
    // Section 1
    
    form +++= Section("Заполните анкету")
    <<< TextRow("firstNameRow") { cell in
      cell.title = "Имя"
    }
    <<< TextRow("lastNameRow") {
      cell in
      cell.title = "Фамилия"
    }
    <<< PushRow<String>("genderRow") { cell in
      cell.title = "Пол"
      let options: [User.Gender] = [.Male, .Female]
      cell.options = options.map() { $0.rawValue.capitalizedString }
    }
    <<< DateInlineRow("birthdateRow") { cell in
      cell.title = "Дата рождения"
      cell.value = NSDate(year: 1990, month: 1, day: 1)
    }
    <<< IntRow("heightRow") { cell in
      cell.title = "Рост"
    }
    <<< IntRow("weightRow") { cell in
      cell.title = "Вес"
    }
  }

  func rowsSetup() {
    
    TextRow.defaultCellSetup = { cell, _ in
      cell.tintColor = UIColor.blueAccentColor()
    }
    
    DateInlineRow.defaultCellSetup = { cell, _ in
      cell.tintColor = UIColor.blueAccentColor()
    }
    
    IntRow.defaultCellSetup = { cell, _ in
      cell.tintColor = UIColor.blueAccentColor()
    }
  }
  
  //MARK: - Actions
  
  func doneButtonAction() {
    
    if let request = request {
      request.cancel()
    }
    
    guard let firstName = form.rowByTag("firstNameRow")?.baseValue as? String else {
      presentAlertWithMessage("Вы не указали свое имя")
      return
    }

    guard let lastName = form.rowByTag("lastNameRow")?.baseValue as? String else {
      presentAlertWithMessage("Вы не указали свою фамилию")
      return
    }
    
    guard let genderValue = form.rowByTag("genderRow")?.baseValue as? String else {
      presentAlertWithMessage("Вы не указали свой пол")
      return
    }
    
    guard let birthdate = form.rowByTag("birthdateRow")?.baseValue as? NSDate else {
      presentAlertWithMessage("Вы не указали дату рождения")
      return
    }
    
    guard let height = form.rowByTag("heightRow")?.baseValue as? Int else {
      presentAlertWithMessage("Вы не указали свой рост")
      return
    }
    
    guard let weight = form.rowByTag("weightRow")?.baseValue as? Int else {
      presentAlertWithMessage("Вы не указали свой вес")
      return
    }
    
    sessionData.firstName = firstName
    sessionData.lastName = lastName
    sessionData.gender = User.Gender(rawValue: genderValue.lowercaseString)!
    sessionData.birthdate = birthdate
    sessionData.height = UInt(height)
    sessionData.weight = UInt(weight)
    
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