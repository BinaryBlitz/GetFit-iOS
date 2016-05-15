//
//  TrainingsViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import CVCalendar
import Reusable

class TrainingsViewController: UIViewController {
  
  var trainings = [WorkoutSession]()
  
  @IBOutlet weak var calendarViewTopConstaraint: NSLayoutConstraint!
  @IBOutlet weak var titleButton: UIButton!
  private let calendarViewHeight: CGFloat = 300
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var calendarView: CVCalendarView!
  
  var refreshControl: UIRefreshControl?
  
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Done, target: self, action: #selector(TrainingsViewController.toggleCurrentDayView))
      case .Closed:
        calendarViewTopConstaraint.constant = -(calendarViewHeight)
        navigationItem.leftBarButtonItem = nil
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
  
  //MARK: - View controller lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    updateTitleDateWithDate(NSDate())
    titleButton.setTitleColor(UIColor.blackTextColor(), forState: .Normal)
    calendarState = .Closed
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
  
  //MARK: - Setup
  func setupTableView() {
    
    tableView.registerReusableCell(TrainingTableViewCell)
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    completion()
  }
  
  //MARK: - Actions
  
  func toggleCurrentDayView() {
    calendarView.toggleCurrentDayView()
  }
  
  @IBAction func titleButtonAction(sender: AnyObject) {
    calendarState.changeToOpositeState()
    
    UIView.animateWithDuration(0.4) { () -> Void in
      self.view.layoutSubviews()
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "trainingInfo":
      let destination = segue.destinationViewController as! TrainingViewController
      let indexPath = sender as! NSIndexPath
      destination.training = trainings[indexPath.row]
    default:
      break
    }
  }
  
  //MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let translation = scrollView.panGestureRecognizer.translationInView(view)
    
    if translation.y < 0 && calendarState != .Closed {
      calendarState = .Closed
      
      UIView.animateWithDuration(0.2) { () -> Void in
        self.view.layoutSubviews()
      }
    }
  }
}

//MARK: - UITableViewDataSource

extension TrainingsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainings.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TrainingTableViewCell
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
    cell.configureWith(TrainingViewModel(training: model))
    
    return cell
  }
}

//MARK: - UITableViewDelegate

extension TrainingsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("trainingInfo", sender: indexPath)
  }
}

//MARK: - CVCalendarViewDelegate

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
    let color = UIColor.blackTextColor()

    let numberOfDots = Int(arc4random_uniform(3) + 1)
    switch(numberOfDots) {
    case 2:
        return [color, color]
    case 3:
        return [color, color, color]
    default:
        return [color]
    }
  }
  
  func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
    return false
  }
  
  func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
    return 13
  }
  
  func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
    return 14
  }

}

//MARK: - CVCalendarMenuViewDelegate

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