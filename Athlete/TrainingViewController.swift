import UIKit
import UICountingLabel
import Reusable
import Moya
import RealmSwift

class TrainingViewController: UIViewController {
  
  var workoutSessionsProvider: APIProvider<GetFit.WorkoutSessions>!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var endTrainingView: UIView!
  @IBOutlet weak var trainingStatusLabel: UICountingLabel!
  @IBOutlet weak var endTrainingButton: UIButton!
  var refreshControl: UIRefreshControl!
  
  var workoutSession: WorkoutSession!
  
  var finishedExercises: Results<ExerciseSession>!
  var exercisesToDo: Results<ExerciseSession>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    endTrainingView.backgroundColor = UIColor.blueAccentColor()
    trainingStatusLabel.text = "0%"
    
    finishedExercises = workoutSession.exercises.filter("completed == true")
    exercisesToDo = workoutSession.exercises.filter("completed == false")
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    updateSessionProgress()
    setupTableView()
    
    refresh()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let selectedCellIndex = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(selectedCellIndex, animated: true)
    }
  }
  
  func setupTableView() {
    tableView.registerReusableCell(ExerciseTableViewCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    
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
    workoutSessionsProvider.request(.ExerciseSessions(workoutSession: workoutSession.id)) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          try self.updateDataWith(response)
        } catch let error {
          self.handleRefreshError(error, withResponse: response)
        }
      case .Failure(let error):
        self.handleRefreshError(error)
      }
      completion()
    }
  }
  
  private func updateDataWith(response: Response) throws {
    let realm = try Realm()
    let exercises = try response.mapArray(ExerciseSession.self)
    
    try realm.write {
      workoutSession.exercises.removeAll()
      realm.add(exercises, update: true)
      workoutSession.exercises.appendContentsOf(exercises)
    }
  }
  
  private func handleRefreshError(error: ErrorType, withResponse response: Response? = nil) {
    if let response = response {
      self.presentAlertWithMessage("server response: \(response.statusCode)")
    } else {
      self.presentAlertWithMessage("omg so bad")
    }
  }
  
  //MARK: - Actions
  
  @IBAction func endTrainingAction(sender: AnyObject) {
    //TODO: update db
    if finishedExercises.count != workoutSession.exercises.count {
      let alert = UIAlertController(title: nil, message: "You didn't complete all your exercises. Finish workout anyway?", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
        self.navigationController?.popViewControllerAnimated(true)
      }))
      alert.addAction(UIAlertAction(title: "Nope", style: .Cancel, handler: nil))
      presentViewController(alert, animated: true, completion: nil)
    } else {
      navigationController?.popViewControllerAnimated(true)
    }
  }
  
  func updateSessionProgress() {
    let total = workoutSession.exercises.count
    guard total > 0 else {
      trainingStatusLabel.textColor = UIColor.whiteColor()
      endTrainingView.backgroundColor = UIColor.blueAccentColor()
      endTrainingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      return
    }
    
    let finishedCount = finishedExercises.count
    trainingStatusLabel.format = "%d%%"
    trainingStatusLabel.countFromCurrentValueTo(CGFloat((finishedCount * 100) / total), withDuration: 0.4)
    if Float((finishedCount * 100) / total) == 100 {
      trainingStatusLabel.textColor = UIColor.blackTextColor()
      endTrainingView.backgroundColor = UIColor.primaryYellowColor()
      endTrainingButton.setTitleColor(UIColor.blackTextColor(), forState: .Normal)
    } else {
      trainingStatusLabel.textColor = UIColor.whiteColor()
      endTrainingView.backgroundColor = UIColor.blueAccentColor()
      endTrainingButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
  }

  //MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "trainingTips":
      break
    case "exerciseInfo":
      let destination = segue.destinationViewController as! ExerciseViewController
      let exercise = sender as! ExerciseSession
      destination.exercise = exercise
    case "editExercise":
      let destinationNavController = segue.destinationViewController as! UINavigationController
      let destination = destinationNavController.viewControllers.first as! EditExerciseTableViewController
      
      if let data = sender as? EditExerciseData {
        destination.exercise = data.exercise
        destination.editType = data.editType
        destination.delegate = self
      }
    default:
      break
    }
  }
}

//MARK: - UITableViewDataSource
extension TrainingViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return finishedExercises.count
    case 2:
      return exercisesToDo.count
    default:
      fatalError("section is out of bounds")
    }
  }
  
  func showTrainingTips(sender: AnyObject) {
    performSegueWithIdentifier("trainingTips", sender: sender)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("trainingInfoCell", forIndexPath: indexPath)
      
      if let avatarImageView = cell.viewWithTag(1) as? UIImageView {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
      }
      
      if let showTipsButton = cell.viewWithTag(2) as? UIButton {
        showTipsButton.backgroundColor = UIColor.blueAccentColor()
        showTipsButton.addTarget(self, action: #selector(TrainingViewController.showTrainingTips(_:)), forControlEvents: .TouchUpInside)
      }
      
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ExerciseTableViewCell
      cell.actionsDelegate = self
      
      let session = finishedExercises[indexPath.row]
      cell.configureWith(ExerciseSessionViewModel(exerciseSession: session))
      addSwipesToCell(cell)
      
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ExerciseTableViewCell
      cell.actionsDelegate = self
      
      let session = exercisesToDo[indexPath.row]
      cell.configureWith(ExerciseSessionViewModel(exerciseSession: session))
      addSwipesToCell(cell)
      
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  private func addSwipesToCell(cell: ExerciseTableViewCell) {
    switch cell.status {
    case .Complete:
      let doneView = UIImageView(image: UIImage(named: "first"))
      doneView.contentMode = .Center

      cell.setSwipeGestureWithView(doneView, color: UIColor.primaryYellowColor(),
          mode: .Exit, state: .State3) { (swipeCell, _, _) -> Void in
            if let indexPath = self.tableView.indexPathForCell(swipeCell) {
              self.tableView.beginUpdates()
              let session = self.finishedExercises[indexPath.row]
              try! session.realm?.write {
                session.completed = false
              }
              self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
              self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableView.numberOfRowsInSection(2), inSection: 2)], withRowAnimation: .Fade)
              self.tableView.endUpdates()
            }
            self.updateSessionProgress()
      }
    case .Uncomplete:
      let doneView = UIImageView(image: UIImage(named: "Checkmark"))
      doneView.contentMode = .Center
    
      cell.setSwipeGestureWithView(doneView, color: UIColor.greenAccentColor(),
          mode: .Exit, state: .State1) { (swipeCell, _, _) -> Void in
            if let indexPath = self.tableView.indexPathForCell(swipeCell) {
              self.tableView.beginUpdates()
              let session = self.exercisesToDo[indexPath.row]
              try! session.realm?.write {
                session.completed = true
              }
              self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
              self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableView.numberOfRowsInSection(1), inSection: 1)], withRowAnimation: .Fade)
              self.tableView.endUpdates()
            }
            
            self.updateSessionProgress()
      }
    }
  }
}

//MARK: - UITableViewDelegate
extension TrainingViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 {
      performSegueWithIdentifier("trainingTips", sender: nil)
    } else {
      performSegueWithIdentifier("exerciseInfo", sender: workoutSession.exercises[indexPath.row])
    }
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 126
    default:
      return 90
    }
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
     return 7
    case 1:
      return finishedExercises.count == 0 ? 0.01 : 7
    case 2:
      return exercisesToDo.count == 0 ? 0.01 : 7
    default:
      return 0.01
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7))
    case 1:
      return finishedExercises.count == 0 ? nil : UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7))
    case 2:
      return exercisesToDo.count == 0 ? nil : UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 7))
    default:
      return nil
    }
  }
}

//MARK: - TrainingTipsDelegate
extension TrainingViewController: TrainingTipsDelegate {
  func didDismissViewController() {
    view.alpha = 1
  }
}

//MARK: - ExerciseCellDelegate
extension TrainingViewController: ExerciseCellDelegate {
  
  class EditExerciseData {
    typealias EditType = EditExerciseTableViewController.EditType
    
    var exercise: ExerciseSession
    var editType: EditType
    
    init(exercise: ExerciseSession, editType: EditType) {
      self.exercise = exercise
      self.editType = editType
    }
  }
  
  func didTapOnRepetitionsButton(cell: UITableViewCell) {
//    guard let indexPath = tableView.indexPathForCell(cell) else {
//      return
//    }
//    
//    let exercise = indexPath.section == 1 ? finishedExercises[indexPath.row] : exercisesToDo[indexPath.row]
//    
    print("didTapOnRepetitionsButton")
//    let data = EditExerciseData(exercise: exercise, editType: .Repetitions)
//    performSegueWithIdentifier("editExercise", sender: data)
  }
  
  func didTapOnWeightButton(cell: UITableViewCell) {
//    guard let indexPath = tableView.indexPathForCell(cell) else {
//      return
//    }
    
    print("didTapOnWeightButton")
//    let exercise = indexPath.section == 1 ? finishedExercises[indexPath.row] : exercisesToDo[indexPath.row]
//    let data = EditExerciseData(exercise: exercise, editType: .Weight)
//    performSegueWithIdentifier("editExercise", sender: data)
  }
}

//MARK: - EditExerciseViewControllerDelegate
extension TrainingViewController: EditExerciseViewControllerDelegate {
  func didUpdateValueForExercise(exercise: ExerciseSession) {
    tableView.reloadData()
  }
}
