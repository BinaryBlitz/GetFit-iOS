//
//  EditExerciseTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

protocol EditExerciseViewControllerDelegate {
  func didUpdateValueForExercise(exercise: ExerciseSession)
}

class EditExerciseTableViewController: UITableViewController {
  
  enum EditType {
    case Weight
    case Repetitions
  }

  var exercise: ExerciseSession!
  var editType: EditType = .Weight
  var delegate: EditExerciseViewControllerDelegate?
  @IBOutlet weak var pickerView: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = editType == .Weight ? "Weight".uppercaseString : "Repetitions".uppercaseString
  
    if editType == .Weight {
      pickerView.selectRow(Int(exercise.weight.value ?? 1) / 10, inComponent: 0, animated: true)
    } else {
      pickerView.selectRow(Int(exercise.reps.value ?? 1), inComponent: 0, animated: true)
    }
    
  }
  
  @IBAction func doneButtonAction(sender: AnyObject) {
    let selectedRow = pickerView.selectedRowInComponent(0)
    if editType == .Weight {
      exercise.weight.value = Int(selectedRow * 10)
    } else {
      exercise.reps.value = selectedRow
    }
    
    delegate?.didUpdateValueForExercise(exercise)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func cancelButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension EditExerciseTableViewController: UIPickerViewDataSource {
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 10
  }
  
  func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
    if let pickerLabel = view as? UILabel {
      pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
      return pickerLabel
    } else {
      let label = view as! UILabel
      label.font = UIFont.boldSystemFontOfSize(19)
      label.textAlignment = NSTextAlignment.Center
      label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
      
      return label
    }
  }
}

extension EditExerciseTableViewController: UIPickerViewDelegate {
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return editType == .Weight ? "\(row * 10) KG" : "\(row) TIMES"
  }
}