import UIKit
import CVCalendar
import Reusable
import RealmSwift
import SwiftDate
import MCSwipeTableViewCell

class WorkoutSessionsViewController: UIViewController {
  
  let workoutSessionsProvider = APIProvider<GetFit.WorkoutSessions>()
  
  var workoutSessions: Results<WorkoutSession>?
  var tableViewDataSource: [WorkoutSession] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
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
        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
        calendarView.contentController.refreshPresentedMonth()
        
        calendarViewTopConstaraint.constant = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: .Done,
                                                           target: self, action: #selector(toggleCurrentDayView))
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
    
    let realm = try! Realm()
    workoutSessions = realm.objects(WorkoutSession).sorted("date")
    updateTableViewDataFor(NSDate())
    
    updateTitleDateWithDate(NSDate())
    titleButton.setTitleColor(UIColor.blackTextColor(), forState: .Normal)
    calendarState = .Closed
    setupTableView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let tabBarController = tabBarController {
      tabBarController.tabBar.tintColor = UIColor.blueAccentColor()
    }
    
    refresh()
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
      self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
      self.calendarView.contentController.refreshPresentedMonth()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    workoutSessionsProvider.request(.Index) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          let sessions = try response.mapArray(WorkoutSession.self)
          self.updateDataWith(sessions)
        } catch let error {
          self.presentAlertWithMessage(String(error))
        }
      case .Failure(let error):
        self.presentAlertWithMessage(String(error))
      }
      
      completion()
    }
  }
  
  private func updateDataWith(workoutSessions: [WorkoutSession]) {
    let indexes = workoutSessions.map { (session) -> Int in return session.id }
    
    let realm = try! Realm()
    try! realm.write {
      realm.add(workoutSessions, update: true)
    }
    
    let storedSessions = realm.objects(WorkoutSession.self)
    let sessionsToDelete = storedSessions.filter { (session) -> Bool in
      return !indexes.contains(session.id)
    }
    
    try! realm.write {
      realm.delete(sessionsToDelete)
    }
    
    if let date = calendarView.presentedDate.convertedDate() {
      updateTableViewDataFor(date)
    }
  }
  
  private func updateTableViewDataFor(date: NSDate) {
    guard let sessions = workoutSessions else { return }
    
    tableViewDataSource = sessions.filter { (session) -> Bool in
      return session.date.isAfter([.Year, .Month, .Day], ofDate: 1.days.agoFromDate(date))
    }
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
  
  @IBAction func addWorkoutSessionsButtonAction(sender: UIButton) {
    let workoutsViewController = WorkoutsTableViewController(style: .Grouped)
    let navigation = UINavigationController(rootViewController: workoutsViewController)
    presentViewController(navigation, animated: true, completion: nil)
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "trainingInfo":
      let destination = segue.destinationViewController as! TrainingViewController
      let indexPath = sender as! NSIndexPath
      destination.training = workoutSessions![indexPath.row]
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
extension WorkoutSessionsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewDataSource.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TrainingTableViewCell
    
    let model = tableViewDataSource[indexPath.row]
    cell.selectionStyle = .None
    setSwipeGesturesFor(cell, in: tableView)
    cell.configureWith(TrainingViewModel(training: model))
    
    return cell
  }
  
  private func setSwipeGesturesFor(cell: MCSwipeTableViewCell, in tableView: UITableView) {
    let doneView = UIImageView(image: UIImage(named: "Checkmark"))
    doneView.contentMode = .Center
    
    let laterView = UIImageView(image: UIImage(named: "Clock"))
    laterView.contentMode = .Center
    
    cell.setSwipeGestureWithView(doneView, color: UIColor.greenAccentColor(),
        mode: .Exit, state: .State1) { (swipeCell, _, _) -> Void in
          print("Done!")
          if let indexPath = tableView.indexPathForCell(swipeCell) {
//            self.workoutSessions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          }
    }
    
    cell.setSwipeGestureWithView(laterView, color: UIColor.primaryYellowColor(),
        mode: .Exit, state: .State3) { (swipeCell, _, _) -> Void in
          print("Later!")
          if let indexPath = tableView.indexPathForCell(swipeCell) {
//            self.workoutSessions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
          }
          
          self.calendarState = .Opened
          UIView.animateWithDuration(0.4) { () -> Void in
            self.view.layoutSubviews()
          }
    }
  }
}

//MARK: - UITableViewDelegate

extension WorkoutSessionsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("trainingInfo", sender: indexPath)
  }
}

//MARK: - CVCalendarViewDelegate

extension WorkoutSessionsViewController: CVCalendarViewDelegate {
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
  
  func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
    guard let date = dayView.date.convertedDate() else { return }
    
    updateTableViewDataFor(date)
  }
  
  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    guard let date = dayView.date.convertedDate() else { return false }
    
    return workoutSessionsFor(date).count != 0
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    guard let date = dayView.date.convertedDate() else { return [] }
    
    let sessionsCount = workoutSessionsFor(date).count
    if sessionsCount > 3 {
      return Array(count: 3, repeatedValue: UIColor.blackTextColor())
    } else {
      return Array(count: sessionsCount, repeatedValue: UIColor.blackTextColor())
    }
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

extension WorkoutSessionsViewController: CVCalendarMenuViewDelegate {

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