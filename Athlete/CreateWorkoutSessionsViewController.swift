import UIKit
import CVCalendar
import RealmSwift
import Moya
import PureLayout

protocol CreateWorkoutSessionsControllerDelegate: class {
  func didFinishWorkoutSessionsCreation()
}

class CreateWorkoutSessionsViewController: UIViewController {
  
  var workout: Workout!
  
  weak var delegate: CreateWorkoutSessionsControllerDelegate?
  
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mounthLabel: UILabel!
  
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var doneButton: ActionButton!
  
  lazy var workoutSessionsProvider = APIProvider<GetFit.WorkoutSessions>()
  
  var workoutSessions: Results<WorkoutSession>!
  var selectedDates: [Date] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    workoutSessions = realm.objects(WorkoutSession.self)
    
    titleLabel.text = "choose date".uppercased()
    
    calendarView.backgroundColor = UIColor.clearColor()
    calendarMenuView.backgroundColor = UIColor.clearColor()
    
    contentView.backgroundColor = UIColor.primaryYellowColor()
    
    doneButton.setTitle("Done".uppercased(), for: UIControlState())
    doneButton.backgroundColor = UIColor.blueAccentColor()
    doneButton.setTitleColor(UIColor.white, for: UIControlState())
    
    updateTitleDateWithDate(Date())
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    calendarView.commitCalendarViewUpdate()
    calendarMenuView.commitMenuViewUpdate()
  }
  
  func updateTitleDateWithDate(_ date: Date) {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    mounthLabel.text = formatter.string(from: date).uppercased()
  }
  
  //MARK: - Actions
  @IBAction func closeButtonAction(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func doneButtonAction(_ sender: ActionButton) {
    sender.showActivityIndicator()
    
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
          self.dismissViewControllerAnimated(true) {
            self.delegate?.didFinishWorkoutSessionsCreation()
          }
        } catch let error {
          self.handleServerError(error, forRespnse: response)
        }
      case .Failure(let error):
        self.handleServerError(error)
      }
      
      sender.hideActivityIndicator()
    }
  }
  
  fileprivate func handleServerError(_ error: Error, forRespnse response: Response? = nil) {
    presentAlertWithMessage("error with code: \(response?.statusCode)")
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
  
  func presentedDateUpdated(_ date: Date) {
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
      colors.append(contentsOf: Array(repeating: UIColor.blackTextColor(), count: 2))
      colors = colors.reversed()
    } else {
      colors.appendContentsOf(Array(count: sessionsCount, repeatedValue: UIColor.blackTextColor()))
      colors = colors.reversed()
    }
    
    
    return colors
  }
  
  fileprivate func workoutSessionsFor(_ date: Date) -> [WorkoutSession] {
    let sessions = workoutSessions?.filter { (session) -> Bool in
      return isDate(session.date, theSameDayAs: date)
    }
    
    return sessions ?? []
  }
  
  fileprivate func isDate(_ date: Date, theSameDayAs otherDate: Date) -> Bool {
    return date.year == otherDate.year &&
           date.month == otherDate.month &&
           date.day == otherDate.day
  }
  
  func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
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
    return UIFont.boldSystemFont(ofSize: 15)
  }
}
