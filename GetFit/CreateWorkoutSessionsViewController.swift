import UIKit
import CVCalendar
import RealmSwift
import Moya
import PureLayout

protocol CreateWorkoutSessionsControllerDelegate: class {
  func willDismissWorkoutController()
  func didFinishWorkoutSessionsCreation()
}

extension CreateWorkoutSessionsControllerDelegate {
  func willDismissWorkoutController() { }
}

class CreateWorkoutSessionsViewController: UIViewController {

  var workout: Workout!

  var workoutSession: WorkoutSession? = nil

  weak var delegate: CreateWorkoutSessionsControllerDelegate?

  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mounthLabel: UILabel!

  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var doneButton: ActionButton!

  lazy var workoutSessionsProvider: APIProvider<GetFit.WorkoutSessions> = APIProvider<GetFit.WorkoutSessions>()

  var workoutSessions: Results<WorkoutSession>!
  var selectedDates: [Date] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    let realm = try! Realm()
    var predicates: [NSPredicate] = []
    predicates.append(NSPredicate(format: "completed == NO"))
    
    if let workoutSession = workoutSession {
      predicates.append(NSPredicate(format: "id != %@", NSNumber(integerLiteral: workoutSession.id)))
      selectedDates.append(workoutSession.date)
    }

    workoutSessions = realm.objects(WorkoutSession.self).filter(NSCompoundPredicate(andPredicateWithSubpredicates: predicates))

    titleLabel.text = "choose date".uppercased()

    calendarView.backgroundColor = UIColor.clear
    calendarMenuView.backgroundColor = UIColor.clear

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

  // MARK: - Actions
  @IBAction func closeButtonAction(_ sender: UIButton) {
    delegate?.willDismissWorkoutController()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func doneButtonAction(_ sender: ActionButton) {
    sender.showActivityIndicator()

    let responseCompletionBlock: Moya.Completion = { result in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          self.delegate?.willDismissWorkoutController()
          self.dismiss(animated: true) {
            self.delegate?.didFinishWorkoutSessionsCreation()
          }
        } catch {
          self.presentAlertWithMessage("error with code: \(response.statusCode)")
        }
      case .failure(let error):
        self.presentAlertWithMessage("error with code: \(error.errorDescription ?? "")")
      }
      sender.hideActivityIndicator()
    }

    if let workoutSession = workoutSession {
      let realm = try! Realm()
      try! realm.write {
        workoutSession.date = selectedDates.first ?? Date()
      }
      workoutSessionsProvider.request(.updateWorkoutSession(session: workoutSession), completion: responseCompletionBlock)
    } else {
      let newSessions = selectedDates.map { (date) -> WorkoutSession in
        let session = WorkoutSession()
        session.updateWith(workout)
        session.date = date
        return session
      }
      workoutSessionsProvider.request(.create(sessions: newSessions), completion: responseCompletionBlock)
    }
  }
}

// MARK: - CVCalendarViewDelegate

extension CreateWorkoutSessionsViewController: CVCalendarViewDelegate {

  func calendar() -> Calendar? {
    return Calendar.current
  }

  func shouldAutoSelectDayOnMonthChange() -> Bool {
    return false
  }

  func presentationMode() -> CalendarMode {
    return .monthView
  }

  func firstWeekday() -> Weekday {
    return .monday
  }

  func shouldShowWeekdaysOut() -> Bool {
    return false
  }

  private func presentedDateUpdated(_ date: Date) {
    updateTitleDateWithDate(date)
  }

  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return false }

    return selectedDates.index(of: date) != nil || workoutSessionsFor(date).count != 0
  }

  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return [] }

    let sessionsCount = workoutSessionsFor(date).count

    var colors: [UIColor] = []

    if selectedDates.contains(date) {
      colors.append(UIColor.blueAccentColor())
    }

    if sessionsCount + colors.count > 3 {
      colors.append(contentsOf: Array(repeating: UIColor.blackTextColor(), count: 2))
      colors = colors.reversed()
    } else {
      colors.append(contentsOf: Array(repeating: UIColor.blackTextColor(), count: sessionsCount))
      colors = colors.reversed()
    }


    return colors
  }

  fileprivate func workoutSessionsFor(_ date: Date) -> [WorkoutSession] {
    let filteredSessions = workoutSessions?.filter { (session) -> Bool in
      return self.isDate(session.date as Date, theSameDayAs: date)
    }

    guard let sessions = filteredSessions else { return [] }

    return Array(sessions)
  }

  fileprivate func isDate(_ date: Date, theSameDayAs otherDate: Date) -> Bool {
    return date.year == otherDate.year &&
      date.month == otherDate.month &&
      date.day == otherDate.day
  }

  func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return }
    guard date.day >= Date().day else {
      presentAlertWithMessage("You can not select past date")
      return calendarView.animator.animateDeselectionOnDayView(dayView)
    }

    if let index = selectedDates.index(of: date) {
      selectedDates.remove(at: index)
    } else {
      if workoutSession != nil { selectedDates.removeAll() }
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

// MARK: - CVCalendarMenuViewDelegate

extension CreateWorkoutSessionsViewController: MenuViewDelegate {

  func weekdaySymbolType() -> WeekdaySymbolType {
    return WeekdaySymbolType.veryShort
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
