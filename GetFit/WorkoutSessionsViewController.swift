import UIKit
import CVCalendar
import Reusable
import RealmSwift
import PureLayout
import SwipeCellKit
import SwiftDate

class WorkoutSessionsViewController: UIViewController {

  lazy var workoutSessionsProvider: APIProvider<GetFit.WorkoutSessions> = APIProvider<GetFit.WorkoutSessions>()
  lazy var workoutsProvider: APIProvider<GetFit.Workouts> = APIProvider<GetFit.Workouts>()

  var currentWorkoutSessions: Results<WorkoutSession>?
  var completedWorkoutSessions: Results<WorkoutSession>?
  var completedSectionDataSource: [WorkoutSession] = []
  var currentSectionDataSource: [WorkoutSession] = []

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
    formatter.locale = Locale(identifier: "en_US")
    let title = formatter.string(from: date).uppercased()
    titleButton.setTitle(title, for: .normal)
    navigationItem.title = title
  }

  // MARK: - View controller lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    let realm = try! Realm()
    currentWorkoutSessions = realm.objects(WorkoutSession.self).filter("completed == false")
    completedWorkoutSessions = realm.objects(WorkoutSession.self).filter("completed == true")
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
      self.fetchWorkouts()
      completion()
    }

  }

  func fetchWorkouts() {
    workoutsProvider.request(.index) { result in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          let workouts = try response.map(to: [Workout.self])
          let realm = try! Realm()
          try! realm.write {
            realm.add(workouts, update: true)
          }
        } catch let error {
          self.presentAlertWithMessage(error.localizedDescription)
        }
      case .failure(let error):
        self.presentAlertWithMessage(error.errorDescription ?? "")
      }
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
    guard let currentWorkoutSessions = self.currentWorkoutSessions else { return }
    guard let completedWorkoutSessions = self.completedWorkoutSessions else { return }
    currentSectionDataSource = currentWorkoutSessions.filter { (session) -> Bool in
      return session.date.isAfter(date: date, orEqual: true, granularity: .day)
    }

    completedSectionDataSource = completedWorkoutSessions.filter { (session) -> Bool in
      return session.date.isAfter(date: date, orEqual: true, granularity: .day)
    }
  }

  fileprivate func updateTableViewData(needReload: Bool = true) {
    if let date = calendarView.presentedDate.convertedDate(calendar: calendar()!) {
      updateTableViewDataFor(date)
      if needReload { tableView.reloadData() }
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
      destination.workoutSession = indexPath.section == 0 ? completedWorkoutSessions![indexPath.row] : currentWorkoutSessions![indexPath.row]
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

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return completedSectionDataSource.count
    case 1:
      return currentSectionDataSource.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as TrainingTableViewCell

    let model = indexPath.section == 0 ? completedSectionDataSource[indexPath.row] : currentSectionDataSource[indexPath.row]
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

  func presentedDateUpdated(_ date: CVDate) {
    updateTitleDateWithDate(date.convertedDate(calendar: calendar()!) ?? Date())
  }

  func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return }

    updateTableViewDataFor(date)
    tableView.reloadData()
  }

  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return false }

    return currentWorkoutSessionsFor(date).count != 0
  }

  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    guard let date = dayView.date.convertedDate(calendar: calendar()!) else { return [] }

    let sessionsCount = currentWorkoutSessionsFor(date).count
    if sessionsCount > 3 {
      return Array(repeating: UIColor.blackTextColor(), count: 3)
    } else {
      return Array(repeating: UIColor.blackTextColor(), count: sessionsCount)
    }
  }

  fileprivate func currentWorkoutSessionsFor(_ date: Date) -> [WorkoutSession] {
    let filteredSessions = currentWorkoutSessions?.filter { (session) -> Bool in
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
    guard orientation == .right, let cell = tableView.cellForRow(at: indexPath) as? TrainingTableViewCell else { return nil }

    switch indexPath.section {
    case 0:
      let action = SwipeAction(style: .default, title: nil) { [weak self ] _, _ in
        guard let indexPath = self?.tableView.indexPath(for: cell),
              let session = self?.completedSectionDataSource[indexPath.row] else { return }
        self?.switchCompleted(session: session, indexPath: indexPath)
      }
      action.image = #imageLiteral(resourceName:"first")
      action.backgroundColor = UIColor.primaryYellowColor()
      return [action]
    case 1:
      let doneAction = SwipeAction(style: .default, title: nil) { [weak self] _, _ in
        guard let indexPath = self?.tableView.indexPath(for: cell),
          let session = self?.currentSectionDataSource[indexPath.row] else { return }
        self?.switchCompleted(session: session, indexPath: indexPath)
      }
      doneAction.image = #imageLiteral(resourceName:"Checkmark")
      doneAction.backgroundColor = UIColor.greenAccentColor()

      let laterAction = SwipeAction(style: .default, title: nil) { [weak self] _, _ in
        guard let indexPath = self?.tableView.indexPath(for: cell),
          let session = self?.currentSectionDataSource[indexPath.row] else { return }
        let realm = try! Realm()
        let trainingsStoryboard = UIStoryboard(name: "Trainings", bundle: nil)
        let selectDaysController = trainingsStoryboard.instantiateViewController(withIdentifier: "select_days") as! CreateWorkoutSessionsViewController
        selectDaysController.workout = realm.object(ofType: Workout.self, forPrimaryKey: session.workoutID)
        selectDaysController.workoutSession = session
        self?.tabBarController?.tabBar.isHidden = true
        selectDaysController.delegate = self
        selectDaysController.modalPresentationStyle = .overCurrentContext
        self?.present(selectDaysController, animated: true, completion: nil)
      }
      laterAction.image = #imageLiteral(resourceName:"Clock")
      laterAction.backgroundColor = UIColor.primaryYellowColor()
      
      return [doneAction, laterAction]
    default:
      return nil
    }
  }


  func switchCompleted(session: WorkoutSession, indexPath: IndexPath) {
    try! session.realm!.write {
      session.completed = !session.completed
      session.synced = false
    }
    workoutSessionsProvider.request(.updateWorkoutSession(session: session)) { [weak self] result in
      switch result {
      case .success(_):
        try! session.realm!.write {
          session.synced = true
        }
        self?.updateTableViewData(needReload: false)
        guard let tableView = self?.tableView else { return }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if session.completed {
          guard let index = self?.completedSectionDataSource.index(of: session) else { return tableView.reloadData() }
          tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
          guard let index = self?.currentSectionDataSource.index(of: session) else { return tableView.reloadData() }
          tableView.insertRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
        }
        tableView.endUpdates()
      case .failure(_):
        try! session.realm!.write {
          session.completed = false
          session.synced = true
        }
        self?.presentAlertWithMessage("An error occured. Please try again")
        self?.tableView.reloadData()
      }
    }
  }

  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
    var options = SwipeTableOptions()
    options.transitionStyle = .border
    return options
  }
}

extension WorkoutSessionsViewController: CreateWorkoutSessionsControllerDelegate {
  func didFinishWorkoutSessionsCreation() {
    tableView.reloadData()
  }
  
  func willDismissWorkoutController() {
    tabBarController?.tabBar.isHidden = false

  }
}
