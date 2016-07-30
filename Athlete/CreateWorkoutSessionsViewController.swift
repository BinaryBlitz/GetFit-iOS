import UIKit
import CVCalendar
import RealmSwift
import Moya

class CreateWorkoutSessionsViewController: UIViewController {
  
  var workout: Workout!
  
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mounthLabel: UILabel!
  
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var doneButton: UIButton!
  
  lazy var workoutSessionsProvider = APIProvider<GetFit.WorkoutSessions>()
  
  var workoutSessions: Results<WorkoutSession>!
  var selectedDates: [NSDate] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    workoutSessions = realm.objects(WorkoutSession.self)
    
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
  
  @IBAction func doneButtonAction(sender: UIButton) {
    sender.userInteractionEnabled = false
    let newSessions = selectedDates.map { (date) -> WorkoutSession in
      let session = WorkoutSession()
      session.updateWith(workout)
      session.date = date
      return session
    }
    
    workoutSessionsProvider.request(.Create(sessions: newSessions)) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          self.presentAlertWithMessage("success!")
          self.dismissViewControllerAnimated(true, completion: nil)
        } catch let error {
          self.handleServerError(error, forRespnse: response)
        }
      case .Failure(let error):
        self.handleServerError(error)
      }
      
      sender.userInteractionEnabled = true
    }
    
  }
  
  private func handleServerError(error: ErrorType, forRespnse response: Response? = nil) {
    presentAlertWithMessage("code: \(response?.statusCode)")
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
    
    return selectedDates.indexOf(date) != nil || workoutSessionsFor(date).count != 0
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    guard let date = dayView.date.convertedDate() else { return [] }
    
    let sessionsCount = workoutSessionsFor(date).count
    
    var colors: [UIColor] = []
    
    if selectedDates.contains(date) {
      colors.append(UIColor.blueAccentColor())
    }
    
    if sessionsCount + colors.count > 3 {
      colors.appendContentsOf(Array(count: 2, repeatedValue: UIColor.blackTextColor()))
      colors = colors.reverse()
    } else {
      colors.appendContentsOf(Array(count: sessionsCount, repeatedValue: UIColor.blackTextColor()))
      colors = colors.reverse()
    }
    
    
    return colors
  }
  
  private func workoutSessionsFor(date: NSDate) -> [WorkoutSession] {
    let sessions = workoutSessions?.filter { (session) -> Bool in
      return isDate(session.date, theSameDayAs: date)
    }
    
    return sessions ?? []
  }
  
  private func isDate(date: NSDate, theSameDayAs otherDate: NSDate) -> Bool {
    return date.year == otherDate.year &&
           date.month == otherDate.month &&
           date.day == otherDate.day
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
