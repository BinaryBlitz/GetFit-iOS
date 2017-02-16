import UIKit
import RealmSwift
import Reusable

class ProgramDetailsTableViewController: UITableViewController {
  
  var program: Program!
  var workouts: Results<Workout>?
  var programsProvider: APIProvider<GetFit.Programs>!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if programsProvider == nil {
      programsProvider = APIProvider<GetFit.Programs>()
    }
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    tableView.registerReusableCell(ProgramTableViewCell)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    let headerNib = UINib(nibName: String(describing: WorkoutHeaderView), bundle: nil)
    tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: String(describing: WorkoutHeaderView))
    
    let realm = try! Realm()
    workouts = realm.objects(Workout).filter("programId == \(program.id)").sorted(byKeyPath: "position")
    
    updateProgramInfo()
  }
  
  func updateProgramInfo() {
    programsProvider.request(.Show(id: program.id)) { (result) in
      switch result {
      case .Success(let response):
        do {
          let programResponse = try response.filterSuccessfulStatusCodes()
          let program = try programResponse.mapObject(Program.self)
          self.program = program
          self.tableView.reloadData()
        } catch let error {
          self.presentAlertWithMessage("error: \(error)")
        }
      case .Failure(let error):
        self.presentAlertWithMessage("error: \(error)")
      }
    }
  }
  
  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1 + (workouts?.count ?? 0)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let workouts = workouts else { return 1 }
    
    if section == 0 {
      return 1
    } else {
      let exercisesCount = workouts[section - 1].exercises.count
      if exercisesCount <= 2 {
        return exercisesCount
      }
      
      return 3
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ProgramTableViewCell
      cell.delegate = self
      cell.state = .Normal
      cell.configureWith(ProgramViewModel(program: program))
      
      cell.trainerAvatar.userInteractionEnabled = true
      cell.trainerAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTrainerPage)))
      
      cell.trainerNameLabel.userInteractionEnabled = true
      cell.trainerNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTrainerPage)))
      
      return cell
    } else {
      guard let exercises = workouts?[indexPath.section - 1].exercises else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell")!
        
      if indexPath.row < 2 {
        cell.textLabel?.text = exercises[indexPath.row].name
      } else {
        cell.textLabel?.textColor = UIColor.blueAccentColor()
        cell.textLabel?.text = "+\(exercises.count - 2) more exercises".uppercased()
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
      }
      
      return cell
    }
  }
  
  @objc fileprivate func openTrainerPage() {
    if program.trainer != nil {
      performSegue(withIdentifier: "showTrainerPage", sender: self)
    } else {
      presentAlertWithMessage("On no! Cannot find trainer")
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0.01
    }
    
    return 40
  }
  
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 9
  }
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 300
    default:
      return 55
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let workouts = workouts, section != 0 && workouts.count > 0 else { return nil }
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: WorkoutHeaderView)) as! WorkoutHeaderView
    let workout = workouts[section - 1]
    headerView.configureWith(workout)
    
    return headerView
  }
  
  //MARK: - Navigation 
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTrainerPage" {
      let destination = segue.destination as! ProfessionalTableViewController
      destination.trainer = program.trainer!
    }
  }
}

//MARK: - ProgramCellDelegate
extension ProgramDetailsTableViewController: ProgramCellDelegate {
  func didTouchBuyButtonInCell(_ cell: ProgramTableViewCell) {
    programsProvider.request(.CreatePurchase(programId: program.id)) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          self.presentAlertWithMessage("Yeah! Program is yours")
        } catch let error {
          self.presentAlertWithMessage("Error: \(error)")
        }
      case .Failure(let error):
        self.presentAlertWithMessage("Error: \(error)")
      }
    }
  }
}
