//
//  TrainingsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import CVCalendar

class TrainingsViewController: UIViewController {
  
  var trainings = [
    Training(name: "Training1", type: .Cardio, duration: 40, date: NSDate()),
    Training(name: "Training2", type: .Running, duration: 20, date: NSDate()),
    Training(name: "Training3", type: .Football, duration: 50, date: NSDate())
  ]
  
  @IBOutlet weak var calendarViewTopConstaraint: NSLayoutConstraint!
  @IBOutlet weak var titleButton: UIButton!
  private let calendarViewHeight: CGFloat = 260
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var calendarView: CVCalendarView!
  
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
      if calendarViewTopConstaraint.constant == 0 {
        return .Opened
      } else if calendarViewTopConstaraint.constant == -(calendarViewHeight) {
        return .Closed
      }
      
      return .InProgress
    }
    set {
      switch newValue {
      case .Opened:
        calendarViewTopConstaraint.constant = 0
      case .Closed:
        calendarViewTopConstaraint.constant = -(calendarViewHeight)
      default:
        break
      }
    }
  }
  
  func updateTitleDateWithDate(date: NSDate) {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MMMM"
    titleButton.setTitle(formatter.stringFromDate(date).uppercaseString, forState: .Normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
    
    updateTitleDateWithDate(NSDate())
    titleButton.setTitleColor(UIColor.blackTextColor(), forState: .Normal)
    calendarState = .Closed
    
    tableView.tableFooterView = UIView()
    
    //add test data
    for training in trainings {
      training.exercises = [
        Exercise(name: "Pushups", repetitions: 4, weight: 80),
        Exercise(name: "Turns", repetitions: 5, weight: 80),
        Exercise(name: "Power Ups", repetitions: 3, weight: 60),
        Exercise(name: "Body Blast", repetitions: 8, weight:  30)
      ]
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    calendarView.commitCalendarViewUpdate()
    calendarMenuView.commitMenuViewUpdate()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let tabBarController = tabBarController {
      tabBarController.tabBar.tintColor = UIColor.blueAccentColor()
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    if let tabBarController = tabBarController {
      tabBarController.tabBar.tintColor = UIColor.whiteColor()
    }
  }
  
  @IBAction func titleButtonAction(sender: AnyObject) {
    calendarState.changeToOpositeState()
    
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.layoutSubviews()
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? TrainingViewController,
        indexPath = sender as? NSIndexPath
        where segue.identifier == "trainingInfo" {
      destination.training = trainings[indexPath.row]
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
        mode: .Exit, state: .State1) { (swipeCell, _, _) -> Void in
          print("Done!")
          if let indexPath = tableView.indexPathForCell(swipeCell) {
            self.trainings.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          }
    }
    
    cell.setSwipeGestureWithView(laterView, color: UIColor.primaryYellowColor(),
        mode: .Exit, state: .State3) { (swipeCell, _, _) -> Void in
          print("Later!")
          if let indexPath = tableView.indexPathForCell(swipeCell) {
            self.trainings.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          }
          
          self.calendarState = .Opened
          UIView.animateWithDuration(0.4) { () -> Void in
            self.view.layoutSubviews()
          }
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
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("trainingInfo", sender: indexPath)
  }
}

extension TrainingsViewController: CVCalendarViewDelegate {
  func presentationMode() -> CalendarMode {
    return .MonthView
  }
  
  func firstWeekday() -> Weekday {
    return .Monday
  }
  
  func shouldShowWeekdaysOut() -> Bool {
    return false
  }
  
  func shouldAutoSelectDayOnMonthChange() -> Bool {
    return false
  }
  
  func presentedDateUpdated(date: Date) {
    if let date = date.convertedDate() {
      updateTitleDateWithDate(date)
    }
  }
  
  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    let number = NSNumber(int: Int32(arc4random_uniform(2)))
    return number.boolValue
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    let randomMasrer = arc4random_uniform(3)
    if randomMasrer == 0 {
      return []
    } else {
      return [UIColor.blueAccentColor()]
    }
  }
  
  func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
    return true
  }
  
  func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
    return 13
  }
  
  func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
    return 16
  }
}

extension TrainingsViewController: CVCalendarMenuViewDelegate {

  func weekdaySymbolType() -> WeekdaySymbolType {
    return WeekdaySymbolType.VeryShort
  }
  func dayOfWeekTextColor() -> UIColor {
    return UIColor.blackTextColor()
  }
  
  func dayOfWeekTextUppercase() -> Bool {
    return true
  }
  
  func dayOfWeekFont() -> UIFont {
    return UIFont.boldSystemFontOfSize(15)
  }
}