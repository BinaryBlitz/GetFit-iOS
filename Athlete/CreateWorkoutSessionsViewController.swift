import UIKit
import CVCalendar

class CreateWorkoutSessionsViewController: UIViewController {
  
  var workout: Workout!
  
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mounthLabel: UILabel!
  
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var doneButton: UIButton!
  
  var workoutSessions: [WorkoutSession] = []
  var selectedDates: [NSDate] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = "choose date".uppercaseString
    
    calendarView.backgroundColor = UIColor.clearColor()
    calendarMenuView.backgroundColor = UIColor.clearColor()
    
    contentView.backgroundColor = UIColor.primaryYellowColor()
    
    doneButton.setTitle("Done".uppercaseString, forState: .Normal)
    doneButton.backgroundColor = UIColor.blueAccentColor()
    doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
    updateTitleDateWithDate(NSDate())
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    calendarView.commitCalendarViewUpdate()
    calendarMenuView.commitMenuViewUpdate()
  }
  
  func updateTitleDateWithDate(date: NSDate) {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MMMM"
    mounthLabel.text = formatter.stringFromDate(date).uppercaseString
  }
  
  //MARK: - Actions
  @IBAction func closeButtonAction(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

//MARK: - CVCalendarViewDelegate
extension CreateWorkoutSessionsViewController: CVCalendarViewDelegate {
  
  func shouldAutoSelectDayOnMonthChange() -> Bool {
    return false
  }
  
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
    guard let date = dayView.date.convertedDate() else { return false }
    
    return selectedDates.indexOf(date) != nil
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    guard let date = dayView.date.convertedDate() else { return [] }
    
    if let _ = selectedDates.indexOf(date) {
      return [UIColor.blueAccentColor()]
    } else {
      return []
    }
  }
  
  func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
    guard let date = dayView.date.convertedDate() else { return }
    
    if let index = selectedDates.indexOf(date) {
      selectedDates.removeAtIndex(index)
    } else {
      selectedDates.append(date)
    }
    
    calendarView.contentController.refreshPresentedMonth()
    calendarView.animator.animateDeselectionOnDayView(dayView)
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
extension CreateWorkoutSessionsViewController: MenuViewDelegate {

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
