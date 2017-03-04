import UIKit
import RealmSwift
import PureLayout
import Reusable

class StoreTableViewController: UITableViewController {

  var programs = [Program]()
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
    programs = Array(realm.objects(Program.self).sorted(byKeyPath: "usersCount"))
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
          self.programs = programs
          let realm = try Realm()
          try realm.write {
            realm.add(programs, update: true)
          }
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
    let numberOfRows = programs.count
    tableView.backgroundView?.isHidden = numberOfRows != 0

    return numberOfRows
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let program = programs[indexPath.row]
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
      destination.program = programs[indexPath.row]
      destination.programsProvider = programsProvider
    default:
      break
    }
  }
}

// MARK: - ProgramCellDelegate

extension StoreTableViewController: ProgramCellDelegate {
  func didTouchBuyButtonInCell(_ cell: ProgramTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let program = programs[indexPath.row]

    programsProvider.request(.createPurchase(programId: program.id)) { (result) in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          self.presentAlertWithMessage("Yeah! Program is yours")
        } catch let error {
          self.presentAlertWithMessage("Error: \(error)")
        }
      case .failure(let error):
        self.presentAlertWithMessage("Error: \(error)")
      }
    }
  }
}
