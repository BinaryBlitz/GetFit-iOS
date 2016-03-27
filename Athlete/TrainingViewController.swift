//
//  TrainingViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import UICountingLabel

class TrainingViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var endTrainingView: UIView!
  @IBOutlet weak var trainingStatusLabel: UICountingLabel!
  @IBOutlet weak var endTrainingButton: UIButton!
  
  var training: Training!
  
  var finishedExercises: [Exercise]!
  var exercisesToDo: [Exercise]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    endTrainingView.backgroundColor = UIColor.blueAccentColor()
    trainingStatusLabel.text = "0%"
    
    finishedExercises = training.exercises.filter { $0.finished }
    exercisesToDo = training.exercises.filter { !($0.finished) }
    
    updateCompleteStatus()
   
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
  }
  
  @IBAction func endTrainingAction(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func updateCompleteStatus() {
    let finishedCount = finishedExercises.count
    let total = training.exercises.count
    trainingStatusLabel.format = "%d%%"
    trainingStatusLabel.countFromCurrentValueTo(CGFloat((finishedCount * 100) / total), withDuration: 0.4)
    if Float((finishedCount * 100) / total) == 100 {
      trainingStatusLabel.textColor = UIColor.blackTextColor()
      endTrainingView.backgroundColor = UIColor.primaryYellowColor()
      endTrainingButton.setTitleColor(UIColor.blackTextColor(), forState: .Normal)
    } else {
      trainingStatusLabel.textColor = UIColor.whiteColor()
      endTrainingView.backgroundColor = UIColor.blueAccentColor()
      endTrainingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? UINavigationController
          where segue.identifier == "trainingTips" {
//      destination.modalPresentationStyle = .OverCurrentContext
    } else if let destination = segue.destinationViewController as? ExerciseViewController,
          exercise = sender as? Exercise
          where segue.identifier == "exerciseInfo" {
        destination.exercise = exercise
    } else if let destinationNavController = segue.destinationViewController as? UINavigationController
          where segue.identifier == "editExercise" {
        let destination = destinationNavController.viewControllers.first as! EditExerciseTableViewController
        if let data = sender as? EditExerciseData {
          destination.exercise = data.exercise
          destination.editType = data.editType
          destination.delegate = self
        }
    }
  }
}

extension TrainingViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return finishedExercises.count
    case 2:
      return exercisesToDo.count
    default:
      fatalError("section is out of bounds")
    }
  }
  
  func showTrainingTips(sender: AnyObject) {
    performSegueWithIdentifier("trainingTips", sender: sender)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("trainingInfoCell",
          forIndexPath: indexPath)
      
      //TODO: do something with the cell
      if let avatarImageView = cell.viewWithTag(1) as? UIImageView {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
      }
      
      if let showTipsButton = cell.viewWithTag(2) as? UIButton {
        showTipsButton.addTarget(self, action: #selector(TrainingViewController.showTrainingTips(_:)), forControlEvents: .TouchUpInside)
      }
      
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("finishedExerciseCell", forIndexPath: indexPath) as? FinishedExerciseTableViewCell else {
        return UITableViewCell()
      }
      
      cell.actionsDelegate = self
      cell.defaultColor = UIColor.primaryYellowColor()
      
      let exercise = finishedExercises[indexPath.row]
      cell.titleLabel.text = exercise.name
      cell.repetitionsButton.setTitle("\(exercise.repetitions) TIMES", forState: .Normal)
      if exercise.weight != 0 {
        cell.weightButton.setTitle("\(exercise.weight) KG", forState: .Normal)
      } else {
//        cell.weightView.hidden = true
      }
      
      let doneView = UIImageView(image: UIImage(named: "first"))
      doneView.contentMode = .Center

      cell.setSwipeGestureWithView(doneView, color: UIColor.primaryYellowColor(),
          mode: .Exit, state: .State3) { (swipeCell, _, _) -> Void in
            print("undo")
            if let indexPath = tableView.indexPathForCell(swipeCell) {
              tableView.beginUpdates()
              self.finishedExercises[indexPath.row].finished = false
              self.exercisesToDo.append(self.finishedExercises[indexPath.row])
              self.finishedExercises.removeAtIndex(indexPath.row)
              tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
              tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: tableView.numberOfRowsInSection(2), inSection: 2)], withRowAnimation: .Fade)
              tableView.endUpdates()
            }
            self.updateCompleteStatus()
      }
      
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath) as? ExerciseTableViewCell else {
        return UITableViewCell()
      }
      
      cell.actionsDelegate = self
      cell.defaultColor = UIColor.greenAccentColor()
      
      let exercise = exercisesToDo[indexPath.row]
      cell.titleLabel.text = exercise.name
      cell.repetitionsButton.setTitle("\(exercise.repetitions) TIMES", forState: .Normal)
      if exercise.weight != 0 {
        cell.weightButton.setTitle("\(exercise.weight) KG", forState: .Normal)
      } else {
//        cell.weightView.hidden = true
      }
      
      let doneView = UIImageView(image: UIImage(named: "Checkmark"))
      doneView.contentMode = .Center
    
      cell.setSwipeGestureWithView(doneView, color: UIColor.greenAccentColor(),
          mode: .Exit, state: .State1) { (swipeCell, _, _) -> Void in
            print("Done!")
            if let indexPath = tableView.indexPathForCell(swipeCell) {
              tableView.beginUpdates()
              self.exercisesToDo[indexPath.row].finished = true
              self.finishedExercises.append(self.exercisesToDo[indexPath.row])
              self.exercisesToDo.removeAtIndex(indexPath.row)
              tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
              tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: tableView.numberOfRowsInSection(1), inSection: 1)], withRowAnimation: .Fade)
              tableView.endUpdates()
            }
            
            self.updateCompleteStatus()
      }
      
      return cell
    default:
      return UITableViewCell()
    }
  }
}

extension TrainingViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      performSegueWithIdentifier("trainingTips", sender: nil)
      // because fuck segues
//      tableView.deselectRowAtIndexPath(indexPath, animated: true)
//      view.alpha = 0.2
//      
//      let destination = storyboard?.instantiateViewControllerWithIdentifier("TraningTips") as! TrainingTipsViewController
//      destination.delegate = self
//      destination.modalPresentationStyle = .OverCurrentContext
//      presentViewController(destination, animated: true, completion: nil)
    } else {
      performSegueWithIdentifier("exerciseInfo", sender: training.exercises[indexPath.row])
    }
  }
  
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 126
    default:
      return 105
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
     return 7
    case 1:
      return finishedExercises.count == 0 ? 0.01 : 7
    case 2:
      return exercisesToDo.count == 0 ? 0.01 : 7
    default:
      return 0.01
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7))
    case 1:
      return finishedExercises.count == 0 ? nil : UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7))
    case 2:
      return exercisesToDo.count == 0 ? nil : UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7))
    default:
      return nil
    }
  }
}

extension TrainingViewController: TrainingTipsDelegate {
  func didDismissViewController() {
    view.alpha = 1
  }
}

extension TrainingViewController: ExerciseCellDelegate {
  
  class EditExerciseData {
    typealias EditType = EditExerciseTableViewController.EditType
    
    var exercise: Exercise
    var editType: EditType
    
    init(exercise: Exercise, editType: EditType) {
      self.exercise = exercise
      self.editType = editType
    }
  }
  
  func didTapOnRepetitionsButton(cell: UITableViewCell) {
    guard let indexPath = tableView.indexPathForCell(cell) else {
      return
    }
    
    let exercise = indexPath.section == 1 ? finishedExercises[indexPath.row] : exercisesToDo[indexPath.row]
    
    print("didTapOnRepetitionsButton")
    let data = EditExerciseData(exercise: exercise, editType: .Repetitions)
    performSegueWithIdentifier("editExercise", sender: data)
  }
  
  func didTapOnWeightButton(cell: UITableViewCell) {
    guard let indexPath = tableView.indexPathForCell(cell) else {
      return
    }
    
    print("didTapOnWeightButton")
    let exercise = indexPath.section == 1 ? finishedExercises[indexPath.row] : exercisesToDo[indexPath.row]
    let data = EditExerciseData(exercise: exercise, editType: .Weight)
    performSegueWithIdentifier("editExercise", sender: data)
  }
}

extension TrainingViewController: EditExerciseViewControllerDelegate {
  func didUpdateValueForExercise(exercise: Exercise) {
    tableView.reloadData()
  }
}
