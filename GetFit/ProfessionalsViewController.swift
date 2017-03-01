import UIKit
import RealmSwift
class ProfessionalsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  fileprivate(set) var selectedCategory: TrainerCategory = .Coach
  let categories: [TrainerCategory] = [.Coach, .Doctor, .Nutritionist]

  let trainersProvider = APIProvider<GetFit.Trainers>()

  var coaches = [Trainer]()
  var doctors = [Trainer]()
  var nutritionists = [Trainer]()

  var refreshControl: UIRefreshControl?

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    setupTableView()

    refresh()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }

  fileprivate func setupTableView() {
    view.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.register(cellType: ProfessionalTableViewCell.self)
    tableView.rowHeight = 370
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()

    tableView.backgroundView = EmptyStateHelper.backgroundViewFor(.trainers)

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }

  func reloadTableViewWith(_ category: TrainerCategory) {
    selectedCategory = category
  }

  // MARK: - Refresh

  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.refreshControl?.endRefreshing()
      self.tableView.reloadData()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    trainersProvider.request(.index(filter: TrainersFilter(category: selectedCategory))) { (result) in
      completion()
      switch result {
      case .success(let response):

        do {
          let trainersResponse = try response.filterSuccessfulStatusCodes()
          let trainers = try trainersResponse.map(to: [Trainer.self]).sorted { $0.id > $1.id }

          let realm = try Realm()
          try realm.write {
            realm.add(trainers, update: true)
          }

          if let trainer = trainers.first {
            switch trainer.category {
            case .Coach:
              self.coaches = trainers
            case .Doctor:
              self.doctors = trainers
            case .Nutritionist:
              self.nutritionists = trainers
            }
          }

          self.tableView.reloadData()
        } catch {
          print("Cannot fetch trainers")
        }

      case .failure(let error):
        print(error)
      }
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? ProfessionalTableViewController,
       let trainer = sender as? Trainer, segue.identifier == "professionalInfo" {
      destination.trainer = trainer
    }
  }

  fileprivate func trainerAtIndexPath(_ indexPath: IndexPath) -> Trainer? {
    var trainer: Trainer? = nil

    switch selectedCategory {
    case .Coach:
      if indexPath.row < coaches.count {
        trainer = coaches[indexPath.row]
      }
    case .Doctor:
      if indexPath.row < doctors.count {
        trainer = doctors[indexPath.row]
      }
    case .Nutritionist:
      if indexPath.row < nutritionists.count {
        trainer = nutritionists[indexPath.row]
      }
    }

    return trainer
  }
}

// MARK: - UITableViewDataSource

extension ProfessionalsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows: Int
    switch selectedCategory {
    case .Coach:
      numberOfRows = coaches.count
    case .Nutritionist:
      numberOfRows = nutritionists.count
    case .Doctor:
      numberOfRows = doctors.count
    }

    tableView.backgroundView?.isHidden = numberOfRows != 0
    return numberOfRows
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let trainer = trainerAtIndexPath(indexPath) else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(for: indexPath) as ProfessionalTableViewCell
    cell.configureWith(trainer)
    cell.state = .card
    cell.delegate = self

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let labels = categories.map { $0.pluralName() }
    let buttonStrip = ButtonsStripView(labels: labels)
    buttonStrip.delegate = self
    buttonStrip.selectedIndex = categories.index(of: selectedCategory) ?? 0

    return buttonStrip
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}

extension ProfessionalsViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let trainer = trainerAtIndexPath(indexPath) else {
      return
    }
    performSegue(withIdentifier: "professionalInfo", sender: trainer)
  }
}

extension ProfessionalsViewController: ButtonStripViewDelegate {

  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedCategory = categories[index]
    refresh()
    tableView.contentOffset = CGPoint.zero
  }
}

extension ProfessionalsViewController: ProfessionalCellDelegate {
  func professionalCell(_ cell: ProfessionalTableViewCell, didChangeFollowingTo: Bool) {
    guard let indexPath = tableView.indexPath(for: cell), let trainer = trainerAtIndexPath(indexPath) else {
      return
    }
    let realm = try! Realm()
    try! realm.write {
      trainer.following = didChangeFollowingTo
      if didChangeFollowingTo {
        trainer.followersCount += 1
      } else {
        trainer.followersCount -= 1
      }
    }

    if didChangeFollowingTo {
      createFollowing(trainer: trainer)
    } else {
      trainersProvider.request(.destroyFollowing(followingId: trainer.followingId)) { _ in }
    }
  }

  func createFollowing(trainer: Trainer) {
    trainersProvider.request(.createFollowing(trainerId: trainer.id)) { result in
      switch result {
      case .success(let response):
        guard let following = try? response.map(to: Following.self) else { return }
        let realm = try! Realm()
        try! realm.write {
          trainer.followingId = following.id
        }
      case .failure(_):
        return
      }
    }
  }
}
