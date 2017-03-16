//
//  SurveyViewController.swift
//  GetFit
//
//  Created by Алексей on 16.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class SurveyViewController: UIViewController {
  var formViewController: SurveyFormViewController? = nil
  var surveyFormCompletedHandler: (() -> Void)? = nil

  static var storyboardInstance: SurveyViewController! {
    let storyboard = UIStoryboard(name: "SurveyForm", bundle: nil)
    return storyboard.instantiateInitialViewController() as! SurveyViewController
  }

  override func viewDidLoad() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeButtonAction))
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "formContainer" else { return }
    guard let viewController = segue.destination as? SurveyFormViewController else { return }
    viewController.delegate = self
    self.formViewController = viewController

  }

  func closeButtonAction() {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func sendButtonDidTap(_ sender: UIButton) {
    sender.isEnabled = false
    guard let formViewController = self.formViewController else { return }
    let surveyFormData = UserManager.currentUser?.surveyFormData ?? SurveyFormData()
    let realm = try! Realm()

    guard let ageText = formViewController.ageField.text, let age = Int(ageText), age < 120 && age > 0 else {
      return presentAlertWithMessage("Age is incorrect")
    }
    guard let weightText = formViewController.weightField.text, let weight = Int(weightText), weight > 0 else {
      return presentAlertWithMessage("Weight is incorrect")
    }
    let trainingDaysCount = Int(formViewController.trainingDaysStepper.value)
    try! realm.write {
      realm.add(surveyFormData, update: true)
      surveyFormData.age = age
      surveyFormData.weight = weight
      surveyFormData.gender = formViewController.gender
      surveyFormData.inventory = formViewController.inventory
      surveyFormData.homeInventory = formViewController.homeInventoryField.text
      surveyFormData.trainingDaysCount = trainingDaysCount
      surveyFormData.trainingLevel = formViewController.trainingLevel
      surveyFormData.trainingGoal = formViewController.trainingGoal
    }
    dismiss(animated: true, completion: { [weak self] in
      self?.surveyFormCompletedHandler?()
    })
  }

}

extension SurveyViewController: SurveyFormViewControllerDelegate {
  func didSelectInventoryCell() {
    let alertController = UIAlertController(title: nil, message: "Есть ли у вас доступ к спортивному инвентарю?", preferredStyle: .alert)
    let gymAction = UIAlertAction(title: SportsInventory.gym.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.inventory = .gym
    })
    let workoutAction = UIAlertAction(title: SportsInventory.workout.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.inventory = .workout
    })
    let homeAction = UIAlertAction(title: SportsInventory.home.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.inventory = .home
    })
    alertController.addAction(gymAction)
    alertController.addAction(workoutAction)
    alertController.addAction(homeAction)
    present(alertController, animated: true, completion: nil)
  }

  func didSelectTrainingLevelCell() {
    let alertController = UIAlertController(title: nil, message: "Физическое состояние", preferredStyle: .alert)
    let beginnerAction = UIAlertAction(title: TrainingLevel.begginer.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.trainingLevel = .begginer
    })
    let fittyAction = UIAlertAction(title: TrainingLevel.fitty.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.trainingLevel = .fitty
    })
    let athleticAction = UIAlertAction(title: TrainingLevel.athletic.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.trainingLevel = .athletic
    })
    alertController.addAction(beginnerAction)
    alertController.addAction(fittyAction)
    alertController.addAction(athleticAction)
    present(alertController, animated: true, completion: nil)
  }

  func didSelectTrainingGoalCell() {
    let trainingGoalSelectViewController = TrainingGoalSelectViewController()
    trainingGoalSelectViewController.didSelectGoalHandler = { [weak self] goal in
      self?.formViewController?.trainingGoal = goal
    }
    navigationController?.pushViewController(trainingGoalSelectViewController, animated: true)
  }

  func didSelectGenderCell() {
    let alertController = UIAlertController(title: nil, message: "Пол", preferredStyle: .alert)
    let maleAction = UIAlertAction(title: Gender.male.localizedDesctiption, style: .default, handler: { [weak self] _ in
     self?.formViewController?.gender = .male
    })
    let femaleAction = UIAlertAction(title: Gender.female.localizedDesctiption, style: .default, handler: { [weak self] _ in
      self?.formViewController?.gender = .female
    })
    alertController.addAction(maleAction)
    alertController.addAction(femaleAction)
    present(alertController, animated: true, completion: nil)
  }
}
