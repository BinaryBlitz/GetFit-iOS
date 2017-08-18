//
//  TrainingGoalSelectViewController.swift
//  GetFit
//
//  Created by Алексей on 16.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class TrainingGoalSelectViewController: UITableViewController {
  var didSelectGoalHandler: ((TrainingGoal) -> Void)? = nil
  var selectedGoal: TrainingGoal = .weightLoss {
    didSet {
      navigationItem.rightBarButtonItem?.isEnabled = true
    }
  }
  let goalOptions: [TrainingGoal] = [.weightLoss, .weightGain, .rapidWeightLoss, .bodyStretching, .enduranceTraining, .strengthTraining, .complexTraining, .other]

  override func viewDidLoad() {
    tableView.allowsMultipleSelection = false
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(self.didTapSaveButton))
    navigationItem.rightBarButtonItem?.isEnabled = false
  }

  func didTapSaveButton() {
    didSelectGoalHandler?(selectedGoal)
    _ = navigationController?.popViewController(animated: true)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return goalOptions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = goalOptions[indexPath.row].localizedDesctiption
    cell.accessoryType = selectedGoal == goalOptions[indexPath.row] ? .checkmark : .none
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedGoal = goalOptions[indexPath.row]
    tableView.reloadRows(at: [indexPath], with: .automatic)
    tableView.reloadData()
  }
}
