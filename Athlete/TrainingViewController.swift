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
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    updateSessionProgress()
    setupTableView()
    
    refresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let selectedCellIndex = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedCellIndex, animated: true)
    }
  }
  
  func setupTableView() {
    tableView.registerReusableCell(ExerciseTableViewCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh) , for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }
  
  //MARK: - Refresh
  
  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    workoutSessionsProvider.request(.exerciseSessions(workoutSession: workoutSession.id)) { (result) in
      switch result {
      case .success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          try self.updateDataWith(response)
        } catch let error {
          self.handleRefreshError(error, withResponse: response)
        }
      case .failure(let error):
        self.handleRefreshError(error)
      }
      completion()
    }
  }
  
  fileprivate func updateDataWith(_ response: Response) throws {
    let realm = try Realm()
    let exercises = try response.mapArray(type: ExerciseSession.self)
    
    try realm.write {
      workoutSession.exercises.removeAll()
      realm.add(exercises, update: true)
      workoutSession.exercises.append(objectsIn: exercises)
    }
  }
  
  fileprivate func handleRefreshError(_ error: Swift.Error, withResponse response: Response? = nil) {
    if let response = response {
      self.presentAlertWithMessage("server response: \(response.statusCode)")
    } else {
      self.presentAlertWithMessage("omg so bad")
    }
  }
  
  //MARK: - Actions
  
  @IBAction func endTrainingAction(_ sender: AnyObject) {
    //TODO: update db
    if finishedExercises.count != workoutSession.exercises.count {
      let alert = UIAlertController(title: nil, message: "You didn't complete all your exercises. Finish workout anyway?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
        self.finishWorkoutSession()
      }))
      alert.addAction(UIAlertAction(title: "Nope", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    } else {
      finishWorkoutSession()
    }
  }
  
  fileprivate func finishWorkoutSession() {
    try! workoutSession.realm?.write {
      workoutSession.completed = true
      workoutSession.synced = false
    }
    navigationController?.popViewController(animated: true)
  }
  
  func updateSessionProgress() {
    let total = workoutSession.exercises.count
    guard total > 0 else {
      trainingStatusLabel.textColor = UIColor.white
      endTrainingView.backgroundColor = UIColor.blueAccentColor()
      endTrainingButton.setTitleColor(UIColor.white, for: UIControlState())
      return
    }
    
    let finishedCount = finishedExercises.count
    trainingStatusLabel.format = "%d%%"
    trainingStatusLabel.countFromCurrentValueTo(CGFloat((finishedCount * 100) / total), withDuration: 0.4)
    if Float((finishedCount * 100) / total) == 100 {
      trainingStatusLabel.textColor = UIColor.blackTextColor()
      endTrainingView.backgroundColor = UIColor.primaryYellowColor()
      endTrainingButton.setTitleColor(UIColor.blackTextColor(), for: UIControlState())
    } else {
      trainingStatusLabel.textColor = UIColor.white
      endTrainingView.backgroundColor = UIColor.blueAccentColor()
      endTrainingButton.setTitleColor(UIColor.white, for: UIControlState())
    }
  }

  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case "trainingTips":
      break
    case "exerciseInfo":
      let destination = segue.destination as! ExerciseViewController
      let exercise = sender as! ExerciseSession
      destination.exercise = exercise
    case "editExercise":
      let destinationNavController = segue.destination as! UINavigationController
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
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
  
  func showTrainingTips(_ sender: AnyObject) {
    performSegue(withIdentifier: "trainingTips", sender: sender)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch (indexPath as NSIndexPath).section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "trainingInfoCell", for: indexPath)
      
      if let avatarImageView = cell.viewWithTag(1) as? UIImageView {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
      }
      
      if let showTipsButton = cell.viewWithTag(2) as? UIButton {
        showTipsButton.backgroundColor = UIColor.blueAccentColor()
        showTipsButton.addTarget(self, action: #selector(TrainingViewController.showTrainingTips(_:)), for: .touchUpInside)
      }
      
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ExerciseTableViewCell
      cell.actionsDelegate = self
      
      let session = finishedExercises[indexPath.row]
      cell.configureWith(ExerciseSessionViewModel(exerciseSession: session))
      addSwipesToCell(cell)
      
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ExerciseTableViewCell
      cell.actionsDelegate = self
      
      let session = exercisesToDo[indexPath.row]
      cell.configureWith(ExerciseSessionViewModel(exerciseSession: session))
      addSwipesToCell(cell)
      
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  fileprivate func addSwipesToCell(_ cell: ExerciseTableViewCell) {
    switch cell.status {
    case .complete:
      let doneView = UIImageView(image: UIImage(named: "first"))
      doneView.contentMode = .center

      cell.setSwipeGestureWith(doneView, color: UIColor.primaryYellowColor(),
          mode: .exit, state: .state3) { (swipeCell, _, _) -> Void in
            if let indexPath = self.tableView.indexPath(for: swipeCell!) {
              self.tableView.beginUpdates()
              let session = self.finishedExercises[indexPath.row]
              try! session.realm?.write {
                session.completed = false
              }
              self.tableView.deleteRows(at: [indexPath], with: .fade)
              self.tableView.insertRows(at: [IndexPath(row: self.tableView.numberOfRows(inSection: 2), section: 2)], with: .fade)
              self.tableView.endUpdates()
            }
            self.updateSessionProgress()
      }
    case .uncomplete:
      let doneView = UIImageView(image: UIImage(named: "Checkmark"))
      doneView.contentMode = .center
    
      cell.setSwipeGestureWith(doneView, color: UIColor.greenAccentColor(),
          mode: .exit, state: .state1) { (swipeCell, _, _) -> Void in
            if let indexPath = self.tableView.indexPath(for: swipeCell!) {
              self.tableView.beginUpdates()
              let session = self.exercisesToDo[indexPath.row]
              try! session.realm?.write {
                session.completed = true
              }
              self.tableView.deleteRows(at: [indexPath], with: .fade)
              self.tableView.insertRows(at: [IndexPath(row: self.tableView.numberOfRows(inSection: 1), section: 1)], with: .fade)
              self.tableView.endUpdates()
            }
            
            self.updateSessionProgress()
      }
    }
  }
}

//MARK: - UITableViewDelegate
extension TrainingViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == 0 {
      performSegue(withIdentifier: "trainingTips", sender: nil)
    } else {
      performSegueWithIdentifier("exerciseInfo", sender: workoutSession.exercises[indexPath.row])
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch (indexPath as NSIndexPath).section {
    case 0:
      return 126
    default:
      return 90
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
  
  func didTapOnRepetitionsButton(_ cell: UITableViewCell) {
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
  
  func didTapOnWeightButton(_ cell: UITableViewCell) {
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
  func didUpdateValueForExercise(_ exercise: ExerciseSession) {
    tableView.reloadData()
  }
}
