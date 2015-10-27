//
//  TrainingsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class TrainingsViewController: UIViewController {
  
  let trainings = [
    Training(name: "Training1", type: .Cardio, duration: 40, date: NSDate()),
    Training(name: "Training2", type: .Running, duration: 20, date: NSDate()),
    Training(name: "Training3", type: .Football, duration: 50, date: NSDate())
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension TrainingsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainings.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("trainingCell") as? TrainingTableViewCell else {
      return UITableViewCell()
    }
    let doneView = UIImageView(image: UIImage(named: "Checkmark"))
    doneView.contentMode = .Center
    
    let laterView = UIImageView(image: UIImage(named: "Clock"))
    laterView.contentMode = .Center
    
    cell.selectionStyle = .None
    
    cell.setSwipeGestureWithView(doneView, color: UIColor.greenAccentColor(),
        mode: .Switch, state: .State1) { (_, _, _) -> Void in
          print("Done!")
    }
    
    cell.setSwipeGestureWithView(laterView, color: UIColor.primaryYellowColor(),
        mode: .Switch, state: .State3) { (_, _, _) -> Void in
          print("Later!")
    }
    
    let model = trainings[indexPath.row]
    cell.titleLabel.text = model.name
    cell.typeLabel.text = "\(model.type.rawValue),"
    cell.durationLabel.text = "\(model.duration) MIN"
    cell.dateLabel.text = stringFromTrainingDate(model.date)
    
    return cell
  }
  
  func stringFromTrainingDate(date: NSDate) -> String {
    let calendar = NSCalendar.currentCalendar()
    let dateCompnents = calendar.components([.Day, .Year, .Month], fromDate: date)
    let currentDateCompnents = calendar.components([.Day, .Year, .Month], fromDate: NSDate())
  
    if dateCompnents.day == currentDateCompnents.day &&
        dateCompnents.year == currentDateCompnents.year &&
        dateCompnents.month == currentDateCompnents.month {
      return "TODAY"
    } else {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "dd/MM"
      return formatter.stringFromDate(date)
    }
  }
  
}

extension TrainingsViewController: UITableViewDelegate {
  
}