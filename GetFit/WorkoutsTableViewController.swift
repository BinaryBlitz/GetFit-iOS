import UIKit
import RealmSwift
import Reusable

class WorkoutsTableViewController: UITableViewController {

  var workouts: Results<Workout>!
  let workoutsProvider = APIProvider<GetFit.Workouts>()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "choose training".uppercased()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self,
      action: #selector(self.closeButtonAction(_:)))

    let realm = try! Realm()
    workouts = realm.objects(Workout.self).sorted(byKeyPath: "duration")
    loadWorkouts()

    tableView.register(cellType: TrainingTableViewCell.self)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
  }

  func loadWorkouts() {
    workoutsProvider.request(.index) { (result) in
      switch result {
      case .success(let response):
        do {
          let workoutsResponse = try response.filterSuccessfulStatusCodes()
          let workouts = try workoutsResponse.map(to: [Workout.self])
          self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)

          let realm = try Realm()
          try realm.write {
            realm.add(workouts, update: true)
          }

          self.tableView.reloadData()
        } catch let error {
          self.presentAlertWithMessage("Error: \(error)")
        }

      case .failure(let error):
        self.presentAlertWithMessage("Error: \(error)")
      }
    }
  }

  // MARK: - Actions

  func closeButtonAction(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workouts.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as TrainingTableViewCell
    let workout = workouts[indexPath.row]

    let workoutSession = WorkoutSession()
    workoutSession.updateWith(workout)
    cell.configureWith(TrainingViewModel(workoutSession: workoutSession))

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return nil
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let trainingsStoryboard = UIStoryboard(name: "Trainings", bundle: nil)
    let selectDaysController = trainingsStoryboard.instantiateViewController(withIdentifier: "select_days") as! CreateWorkoutSessionsViewController
    selectDaysController.workout = workouts[indexPath.row]
    selectDaysController.delegate = self

    selectDaysController.modalPresentationStyle = .overCurrentContext
    present(selectDaysController, animated: true, completion: nil)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - CreateWorkoutSessionsControllerDelegate

extension WorkoutsTableViewController: CreateWorkoutSessionsControllerDelegate {
  func didFinishWorkoutSessionsCreation() {
    dismiss(animated: true, completion: nil)
  }
}
