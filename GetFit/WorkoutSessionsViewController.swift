import UIKit
import CVCalendar
import Reusable
import RealmSwift
import PureLayout
import SwipeCellKit
import SwiftDate

class WorkoutSessionsViewController: UIViewController {

  lazy var workoutSessionsProvider: APIProvider<GetFit.WorkoutSessions> = APIProvider<GetFit.WorkoutSessions>()

  var workoutSessions: Results<WorkoutSession>?
  var tableViewDataSource: [WorkoutSession] = []

  @IBOutlet weak var calendarViewTopConstaraint: NSLayoutConstraint!
  @IBOutlet weak var titleButton: UIButton!
  fileprivate let calendarViewHeight: CGFloat = 300
  @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var calendarView: CVCalendarView!

  var refreshControl: UIRefreshControl?

  enum CalendarState {
    case opened
    case inProgress
    case closed

    mutating func changeToOpositeState() {
      switch self {
      case .opened:
        self = .closed
      case .closed:
        self = .opened
      default:
        break
      }
    }
  }

  var calendarState: CalendarState {
    get {
      if calendarViewTopConstaraint.constant == 0 {
        return .opened
      } else if calendarViewTopConstaraint.constant == -(calendarViewHeight) {
        return .closed
      }

      return .inProgress
    }
    set {
      switch newValue {
      case .opened:
        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
        calendarView.contentController.refreshPresentedMonth()

        calendarViewTopConstaraint.constant = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .done,
          target: self, action: #selector(toggleCurrentDayView))
      case .closed:
        calendarViewTopConstaraint.constant = -(calendarViewHeight)
        navigationItem.leftBarButtonItem = nil
      default:
        break
      }
    }
  }

  func updateTitleDateWithDate(_ date: Date) {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    titleButton.setTitle(formatter.string(from: date).uppercased(), for: UIControlState())
  }

  // MARK: - View controller lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    let realm = try! Realm()
    workoutSessions = realm.objects(WorkoutSession.self).filter("completed == false").sorted(byKeyPath: "date")
    updateTableViewDataFor(Date())

    updateTitleDateWithDate(Date())
    tableView.reloadData()
    titleButton.setTitleColor(UIColor.blackTextColor(), for: UIControlState())
    calendarState = .closed
    setupTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let tabBarController = tabBarController {
      tabBarController.tabBar.tintColor = UIColor.blueAccentColor()
    }

    updateTableViewData()
    refresh()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let tabBarController = tabBarController {
      tabBarController.tabBar.tintColor = UIColor.white
    }
  }

  // MARK: - Setup

  func setupTableView() {
    tableView.register(cellType: TrainingTableViewCell.self)
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }

  // MARK: - Refresh

  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.calendarView.contentController.refreshPresentedMonth()
      self.refreshControl?.endRefreshing()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    workoutSessionsProvider.request(.index) { (result) in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          let sessions = try response.map(to: [WorkoutSession.self])
          self.updateDataWith(sessions)
        } catch let error {
          self.presentAlertWithMessage(error.localizedDescription)
        }
      case .failure(let error):
        self.presentAlertWithMessage(error.errorDescription ?? "")
      }

      completion()
    }
  }

  fileprivate func updateDataWith(_ workoutSessions: [WorkoutSession]) {
    let indexes = workoutSessions.map { (session) -> Int in return session.id }

    let realm = try! Realm()

    let storedSessions = realm.objects(WorkoutSession.self)
    try! realm.write {
      workoutSessions.forEach { session in
        if let storedSession = realm.object(ofType: WorkoutSession.self, forPrimaryKey: session.id as AnyObject) {
          if storedSession.synced {
            realm.add(session, update: true)
          }
        } else {
          realm.add(session)
        }
      }
    }

    let sessionsToDelete = storedSessions.filter { (session) -> Bool in
      return !indexes.contains(session.id)
    }

    try! realm.write {
      realm.delete(sessionsToDelete)
    }

    if let date = calendarView.presentedDate.convertedDate(calendar: calendar()!) {
      updateTableViewDataFor(date)
      tableView.reloadData()
    }
  }

  fileprivate func updateTableViewDataFor(_ date: Date) {
    guard let sessions = workoutSessions else { return }

    tableViewDataSource = sessions.filter { (session) -> Bool in
      return session.date.isAfter(date: date, granularity: .day)
    }
  }

  fileprivate func updateTableViewData() {
    if let date = calendarView.presentedDate.convertedDate(calendar: calendar()!) {
      updateTableViewDataFor(date)
      tableView.reloadData()
    }
  }

  // MARK: - Actions

  func toggleCurrentDayView() {
    calendarView.toggleCurrentDayView()
  }
  
  @IBAction func navigationtTitleAction(_ sender: Any) {
    calendarState.changeToOpositeState()

    UIView.animate(withDuration: 0.4, animations: { () -> Void in
      self.view.layoutSubviews()
    })
  }


  @IBAction func addWorkoutSessionsButtonAction(_ sender: UIButton) {
    let workoutsViewController = WorkoutsTableViewController(style: .grouped)
    let navigation = UINavigationController(rootViewController: workoutsViewController)
    present(navigation, animated: true, completion: nil)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }

    switch identifier {
    case "trainingInfo":
      let destination = segue.destination as! TrainingViewController
      let indexPath = sender as! IndexPath
      destination.workoutSession = workoutSessions![indexPath.row]
      destination.workoutSessionsProvider = workoutSessionsProvider
    default:
      break
    }
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let translation = scrollView.panGestureRecognizer.translation(in: view)

    if translation.y < 0 && calendarState != .closed {
      calendarState = .closed

      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        self.view.layoutSubviews()
      })
    }
  }
}

// MARK: - UITableViewDataSource

extension WorkoutSessionsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewDataSource.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as TrainingTableViewCell

    let model = tableViewDataSource[indexPath.row]
    cell.selectionStyle = .none
    cell.delegate = self
    cell.configureWith(TrainingViewModel(workoutSession: model))

    return cell
  }
}

// MARK: - UITableViewDelegate

extension WorkoutSessionsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "trainingInfo", sender: indexPath)
  }
}

// MARK: - CVCalendarViewDelegate

extension WorkoutSessionsViewController: CVCalendarViewDelegate {

  func calendar() -> Calendar? {
    return Calendar.current
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

  func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return }

    updateTableViewDataFor(date)
    tableView.reloadData()
  }

  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return false }

    return workoutSessionsFor(date).count != 0
  }

  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return [] }

    let sessionsCount = workoutSessionsFor(date).count
    if sessionsCount > 3 {
      return Array(repeating: UIColor.blackTextColor(), count: 3)
    } else {
      return Array(repeating: UIColor.blackTextColor(), count: sessionsCount)
    }
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

extension WorkoutSessionsViewController: CVCalendarMenuViewDelegate {

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

// MARK: - SwipeTableViewCellDelegate

extension WorkoutSessionsViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    guard let cell = tableView.cellForRow(at: indexPath) as? TrainingTableViewCell else { return [] }
    let doneAction = SwipeAction(style: .destructive, title: nil) { _, _ in
      guard let indexPath = self.tableView.indexPath(for: cell) else { return }
      let session = self.tableViewDataSource[indexPath.row]
      try! session.realm!.write {
        session.completed = true
        session.synced = false
      }
      self.tableViewDataSource.remove(at: indexPath.row)
    }
    doneAction.image = #imageLiteral(resourceName:"Checkmark")
    doneAction.backgroundColor = UIColor.greenAccentColor()
    return [doneAction]
  }

  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
    var options = SwipeTableOptions()
    options.expansionStyle = .destructive
    options.transitionStyle = .border
    return options
  }
}
