import UIKit

protocol EditExerciseViewControllerDelegate {
  func didUpdateValueForExercise(_ exercise: ExerciseSession)
}

class EditExerciseTableViewController: UITableViewController {
  
  enum EditType {
    case weight
    case repetitions
  }

  var exercise: ExerciseSession!
  var editType: EditType = .weight
  var delegate: EditExerciseViewControllerDelegate?
  @IBOutlet weak var pickerView: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = editType == .weight ? "Weight".uppercased() : "Repetitions".uppercased()
  
    if editType == .weight {
      pickerView.selectRow(Int(exercise.weight.value ?? 1) / 10, inComponent: 0, animated: true)
    } else {
      pickerView.selectRow(Int(exercise.reps.value ?? 1), inComponent: 0, animated: true)
    }
    
  }
  
  @IBAction func doneButtonAction(_ sender: AnyObject) {
    let selectedRow = pickerView.selectedRow(inComponent: 0)
    if editType == .weight {
      exercise.weight.value = Int(selectedRow * 10)
    } else {
      exercise.reps.value = selectedRow
    }
    
    delegate?.didUpdateValueForExercise(exercise)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancelButtonAction(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
}

extension EditExerciseTableViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 10
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    if let pickerLabel = view as? UILabel {
      pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
      return pickerLabel
    } else {
      let label = view as! UILabel
      label.font = UIFont.boldSystemFont(ofSize: 19)
      label.textAlignment = NSTextAlignment.center
      label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
      
      return label
    }
  }
}

extension EditExerciseTableViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return editType == .weight ? "\(row * 10) KG" : "\(row) TIMES"
  }
}
