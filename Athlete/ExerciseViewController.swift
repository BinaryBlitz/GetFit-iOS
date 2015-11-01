//
//  ExerciseViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 31/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
  
  @IBOutlet weak var endExerciseButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  var exercise: Exercise!
  
  let content = [("title", 1.46), ("video1", 2.8), ("video2", 2.8)]

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    endExerciseButton.backgroundColor = UIColor.blueAccentColor()
    
    navigationItem.title = exercise.name
  }
  
  @IBAction func endExerciseAction(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func showTrainingTips(recognizer: UITapGestureRecognizer) {
    performSegueWithIdentifier("trainingTips", sender: self)
  }
}

extension ExerciseViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return content.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath)
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        imageView.image = UIImage(named: content[indexPath.row].0)
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showTrainingTips:"))
      }
      return cell
    case 1, 2:
      let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath)
      cell.backgroundColor = UIColor.lightGrayBackgroundColor()
      
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        imageView.image = UIImage(named: content[indexPath.row].0)
      }
      
      return cell
    default:
      return UITableViewCell()
    }
  }
}

extension ExerciseViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let width = indexPath.row == 0 ? tableView.frame.width : tableView.frame.width - 32
    
    return width / CGFloat(content[indexPath.row].1)
  }
}
