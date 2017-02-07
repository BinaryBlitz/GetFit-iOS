import UIKit
import RealmSwift
import Reusable

class WorkoutsTableViewController: UITableViewController {
  
  var workouts: Results<Workout>!
  let workoutsProvider = APIProvider<GetFit.Workouts>()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "choose training".uppercaseString
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self,
                                                       action: #selector(self.closeButtonAction(_:)))
    
    let realm = try! Realm()
    workouts = realm.objects(Workout).sorted("duration")
    loadWorkouts()
    
    tableView.registerReusableCell(TrainingTableViewCell)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
  }
  
  func loadWorkouts() {
    workoutsProvider.request(.Index) { (result) in
      switch result {
      case .Success(let response):
        do {
          let workoutsResponse = try response.filterSuccessfulStatusCodes()
          let workouts = try workoutsResponse.mapArray(Workout.self)
          self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
          
          let realm = try Realm()
          try realm.write {
            realm.add(workouts, update: true)
          }
          
          self.tableView.reloadData()
        } catch let error {
          self.presentAlertWithMessage("Error: \(error)")
        }
        
      case .Failure(let error):
        self.presentAlertWithMessage("Error: \(error)")
      }
    }
  }
  
  //MARK: - Actions
  
  func closeButtonAction(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workouts.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TrainingTableViewCell
    let workout = workouts[indexPath.row]
    
    let workoutSession = WorkoutSession()
    workoutSession.updateWith(workout)
    cell.configureWith(TrainingViewModel(workoutSession: workoutSession))
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.01
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return nil
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let trainingsStoryboard = UIStoryboard(name: "Trainings", bundle: nil)
    let selectDaysController = trainingsStoryboard.instantiateViewControllerWithIdentifier("select_days") as! CreateWorkoutSessionsViewController
    selectDaysController.workout = workouts[indexPath.row]
    selectDaysController.delegate = self
    
    selectDaysController.modalPresentationStyle = .OverCurrentContext
    presentViewController(selectDaysController, animated: true, completion: nil)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

//MARK: - CreateWorkoutSessionsControllerDelegate
extension WorkoutsTableViewController: CreateWorkoutSessionsControllerDelegate {
  func didFinishWorkoutSessionsCreation() {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
