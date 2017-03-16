//
//  SurveyFormViewController.swift
//  GetFit
//
//  Created by Алексей on 16.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

protocol SurveyFormViewControllerDelegate: class {
  func didSelectGenderCell()
  func didSelectTrainingLevelCell()
  func didSelectTrainingGoalCell()
  func didSelectInventoryCell()
}

class SurveyFormViewController: UITableViewController {
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet weak var weightField: UITextField!
  @IBOutlet weak var trainingLevelLabel: UILabel!
  @IBOutlet weak var trainingDaysCountLabel: UILabel!
  @IBOutlet weak var trainingDaysStepper: UIStepper!
  @IBOutlet weak var goalLabel: UILabel!
  @IBOutlet weak var inventoryLabel: UILabel!
  @IBOutlet weak var homeInventoryField: UITextView!

  var gender: Gender = .male {
    didSet {
      genderLabel.text = gender.localizedDesctiption
    }
  }

  var trainingLevel: TrainingLevel = .begginer {
    didSet {
      trainingLevelLabel.text = trainingLevel.localizedDesctiption
    }
  }

  var trainingGoal: TrainingGoal = .weightLoss {
    didSet {
      trainingLevelLabel.text = trainingGoal.localizedDesctiption
    }
  }

  var inventory: SportsInventory = .gym {
    didSet {
      inventoryLabel.text = inventory.localizedDesctiption
    }
  }

  var delegate: SurveyFormViewControllerDelegate? = nil

  var isFirstForm: Bool = UserManager.currentUser?.surveyFormData == nil

  enum Sections: Int {
    case form
    case homeInventory

    static let count = 0
  }

  enum FormRows: Int {
    case gender
    case age
    case weight
    case level
    case trainingDaysCount
    case goal
    case inventory

    static let count = 7
  }

  override func viewDidLoad() {
  }

  func configureForm() {
    guard let surveyData = UserManager.currentUser?.surveyFormData else { return }
    gender = surveyData.gender
    ageField.text = "\(surveyData.age)"
    weightField.text = "\(surveyData.weight)"
    trainingLevel = surveyData.trainingLevel
    trainingGoal = surveyData.trainingGoal
    inventory = surveyData.inventory
    homeInventoryField.text = surveyData.homeInventory
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return isFirstForm ? 2 : 1
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == Sections.form.rawValue else { return }
    switch indexPath.row {
    case FormRows.gender.rawValue:
      delegate?.didSelectGenderCell()
    case FormRows.level.rawValue:
      delegate?.didSelectTrainingLevelCell()
    case FormRows.goal.rawValue:
      delegate?.didSelectTrainingGoalCell()
    case FormRows.inventory.rawValue:
      delegate?.didSelectInventoryCell()
    default:
      break
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    guard indexPath.section == Sections.form.rawValue else { return false }
    switch indexPath.row {
    case FormRows.gender.rawValue, FormRows.level.rawValue, FormRows.goal.rawValue, FormRows.inventory.rawValue:
      return true
    default:
      return false
    }
  }

  @IBAction func trainingDaysStepperValueChanged(_ sender: UIStepper) {
    trainingDaysCountLabel.text = "\(Int(sender.value))"
  }

}
