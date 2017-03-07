import UIKit
import Reusable
import Moya
import RealmSwift
import SwipeCellKit

class TrainingViewController: UIViewController {

  var workoutSessionsProvider: APIProvider<GetFit.WorkoutSessions>!

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var endTrainingView: UIView!
  @IBOutlet weak var trainingStatusLabel: UILabel!
  @IBOutlet weak var endTrainingButton: UIButton!
  var refreshControl: UIRefreshControl!

  var workoutSession: WorkoutSession!

  var finishedExercises: Results<ExerciseSession> {
    return workoutSession.exercises.filter("completed == true")
  }
  var exercisesToDo: Results<ExerciseSession> {
    return workoutSession.exercises.filter("completed == false")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = workoutSession.workoutName.uppercased()

    endTrainingView.backgroundColor = UIColor.blueAccentColor()
    trainingStatusLabel.text = "0%"

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
    tableView.register(cellType: ExerciseTableViewCell.self)
    tableView.rowHeight = UITableViewAutomaticDimension

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
      self.refreshControl?.endRefreshing()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    workoutSessionsProvider.request(.exerciseSessions(workoutSession: workoutSession.id)) { (result) in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          try self.updateDataWith(response)
        } catch {
          self.presentAlertWithMessage("server response: \(response.statusCode)")
        }
      case .failure(let error):
        self.presentAlertWithMessage(error.errorDescription)
      }
      completion()
    }
  }

  fileprivate func updateDataWith(_ response: Response) throws {
    let realm = try Realm()
    let exercises = try response.map(to: [ExerciseSession.self])

    try realm.write {
      workoutSession.exercises.removeAll()
      realm.add(exercises, update: true)
      workoutSession.exercises.append(objectsIn: exercises)
    }
  }

  // MARK: - Actions

  @IBAction func endTrainingAction(_ sender: AnyObject) {
    // TODO: update db
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
    _ = navigationController?.popViewController(animated: true)
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
    trainingStatusLabel.text = "\(Int((finishedCount * 100) / total))%"
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

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }

    switch identifier {
    case "trainingTips":
      let destination = segue.destination as! TrainingTipsViewController
      destination.tips = workoutSession.programTips
    case "exerciseInfo":
      let destination = segue.destination as! ExerciseViewController
      let exerciseSession = sender as! ExerciseSession
      destination.exerciseSession = exerciseSession
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

// MARK: - UITableViewDataSource

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
    switch indexPath.section {
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
      cell.delegate = self

      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ExerciseTableViewCell
      cell.actionsDelegate = self
      let session = exercisesToDo[indexPath.row]
      cell.configureWith(ExerciseSessionViewModel(exerciseSession: session))
      cell.delegate = self

      return cell
    default:
      return UITableViewCell()
    }
  }
}

// MARK: - UITableViewDelegate

extension TrainingViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      performSegue(withIdentifier: "trainingTips", sender: nil)
    } else {
      performSegue(withIdentifier: "exerciseInfo", sender: workoutSession.exercises[indexPath.row])
    }
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
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

// MARK: - TrainingTipsDelegate

extension TrainingViewController: TrainingTipsDelegate {
  func didDismissViewController() {
    view.alpha = 1
  }
}

// MARK: - ExerciseCellDelegate

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

// MARK: - EditExerciseViewControllerDelegate

extension TrainingViewController: EditExerciseViewControllerDelegate {
  func didUpdateValueForExercise(_ exercise: ExerciseSession) {
    tableView.reloadData()
  }
}

extension TrainingViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    guard indexPath.section == 1 || indexPath.section == 2 else { return [] }
    guard let cell = tableView.cellForRow(at: indexPath) as? ExerciseTableViewCell else { return [] }
    switch cell.status {
    case .complete:
      let action = SwipeAction(style: .default, title: "") { _, _ in
        if let indexPath = self.tableView.indexPath(for: cell) {
          self.tableView.beginUpdates()
          let session = self.finishedExercises[indexPath.row]
          try! session.realm?.write {
            session.completed = false
          }
          self.tableView.deleteRows(at: [indexPath], with: .fade)
          self.tableView.insertRows(at: [IndexPath(row: self.exercisesToDo.index(of: session)!, section: 2)], with: .fade)
          self.tableView.endUpdates()
        }
        self.updateSessionProgress()
      }
      action.image = #imageLiteral(resourceName:"first")
      action.backgroundColor = UIColor.primaryYellowColor()
      return [action]
    case .uncomplete:
      let action = SwipeAction(style: .default, title: "") { _, _ in
        if let indexPath = self.tableView.indexPath(for: cell) {
          self.tableView.beginUpdates()
          let session = self.exercisesToDo[indexPath.row]
          try! session.realm?.write {
            session.completed = true
          }
          self.tableView.deleteRows(at: [indexPath], with: .fade)
          self.tableView.insertRows(at: [IndexPath(row: self.finishedExercises.index(of: session)!, section: 1)], with: .fade)
          self.tableView.endUpdates()
        }
        self.updateSessionProgress()
      }
      action.image = #imageLiteral(resourceName:"Checkmark")
      action.backgroundColor = UIColor.greenAccentColor()
      return [action]
    }
  }
}
