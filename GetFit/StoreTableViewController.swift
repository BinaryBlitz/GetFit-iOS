import UIKit
import RealmSwift
import SwiftyJSON
import PureLayout
import Reusable

class StoreTableViewController: UITableViewController {

  var programs: Results<Program>? = nil
  let programsProvider = APIProvider<GetFit.Programs>()

  override func viewDidLoad() {
    super.viewDidLoad()

    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .plain,
      target: nil,
      action: nil
    )

    configureTableView()
    fetchPrograms()
  }

  func configureTableView() {
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()

    tableView.register(cellType: ProgramTableViewCell.self)

    tableView.backgroundView = createBackgroundView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 265

    tableView.backgroundView = EmptyStateHelper.backgroundViewFor(.store)

    let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
    header.backgroundColor = UIColor.clear
    tableView.tableHeaderView = header

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)

    refresh()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  func createBackgroundView() -> UIView {
    let view = UIView()
    let label = UILabel()

    // TODO: localize
    label.text = "No programs"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 22)
    label.textColor = UIColor.graySecondaryColor()

    view.addSubview(label)
    label.autoPinEdge(toSuperviewEdge: .left)
    label.autoPinEdge(toSuperviewEdge: .right)
    label.autoPinEdge(toSuperviewEdge: .bottom)
    label.autoPinEdge(toSuperviewEdge: .top, withInset: -50, relation: .equal)

    return view
  }

  func fetchPrograms() {
    let realm = try! Realm()
    programs = realm.objects(Program.self).sorted(byKeyPath: "usersCount")
  }

  // MARK: - Refresh

  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    programsProvider.request(.index(filter: ProgramsFilter())) { (result) in
      switch result {
      case .success(let response):

        do {
          let programsResponse = try response.filterSuccessfulStatusCodes()
          let programs = try programsResponse.map(to: [Program.self])
          let realm = try Realm()
          try realm.write {
            realm.add(programs, update: true)
          }
          self.tableView.reloadData()
        } catch {
          print("Cannot update programs")
        }

      case .failure(let error):
        print(error)
      }
      completion()
    }
  }

  // MARK: - TableView DataSource and Delegate

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = programs?.count ?? 0
    tableView.backgroundView?.isHidden = numberOfRows != 0

    return numberOfRows
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let program = programs?[indexPath.row] else { return UITableViewCell() }
    let cell = tableView.dequeueReusableCell(for: indexPath) as ProgramTableViewCell
    cell.delegate = self
    cell.state = .card
    cell.configureWith(ProgramViewModel(program: program))

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "programDetails", sender: indexPath)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }

    switch identifier {
    case "programDetails":
      let destination = segue.destination as! ProgramDetailsTableViewController
      let indexPath = sender as! IndexPath
      guard let program = programs?[indexPath.row] else { return }
      destination.program = program
      destination.programsProvider = programsProvider
    default:
      break
    }
  }
}

extension StoreTableViewController: ProgramCellDelegate {
  func didTouchBuyButtonInCell(_ cell: ProgramTableViewCell, button: UIButton) {
    button.isEnabled = false
    guard let indexPath = tableView.indexPath(for: cell), let program = programs?[indexPath.row] else { return }

    if program.isPurchased {
      let workoutsViewController = WorkoutsTableViewController(style: .grouped)
      workoutsViewController.program = program
      let navigation = UINavigationController(rootViewController: workoutsViewController)
      present(navigation, animated: true, completion: nil)
    } else {
      guard UserManager.currentUser?.surveyFormData == nil else {
        return purchase(program: program, buyButton: button, indexPath: indexPath)
      }
      let surveyViewController = SurveyViewController.storyboardInstance!
      let viewController = UINavigationController(rootViewController: surveyViewController)
      surveyViewController.surveyFormCompletedHandler = { [weak self] finished in
        if finished {
          self?.purchase(program: program, buyButton: button, indexPath: indexPath)
        } else {
          button.isEnabled = true
        }
      }
      present(viewController, animated: true, completion: nil)

    }
  }

  func purchase(program: Program, buyButton: UIButton, indexPath: IndexPath) {

    PurchaseManager.instance.buy(program: program) { [weak self] result in
      buyButton.isEnabled = true
      switch result {
      case .success:
        self?.tableView.reloadRows(at: [indexPath], with: .none)
      case .failure(let error):
        self?.presentAlertWithMessage("Error: \(error)")
      }
    }
  }
}
