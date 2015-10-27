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
  
  @IBOutlet weak var titleButton: UIButton!
  @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
  private let calendarViewHeight: CGFloat = 260
  
  enum CalendarState {
    case Opened
    case InProgress
    case Closed
    
    mutating func changeToOpositeState() {
      switch self {
      case .Opened:
        self = .Closed
      case .Closed:
        self = .Opened
      default:
        break
      }
    }
  }
  
  var calendarState: CalendarState {
    get {
      if calendarViewHeightConstraint.constant == calendarViewHeight {
        return .Opened
      } else if calendarViewHeightConstraint.constant == 0 {
        return .Closed
      }
      
      return .InProgress
    }
    set {
      switch newValue {
      case .Opened:
        calendarViewHeightConstraint.constant = self.calendarViewHeight
      case .Closed:
        calendarViewHeightConstraint.constant = 0
      default:
        break
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleButton.setTitleColor(UIColor.blackTextColor(), forState: .Normal)
    calendarState = .Closed
  }
  
  @IBAction func titleButtonAction(sender: AnyObject) {
    calendarState.changeToOpositeState()
    
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.layoutIfNeeded()
    }
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