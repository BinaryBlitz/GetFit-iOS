import UIKit
import RealmSwift
import Moya
import Reusable

class ProfessionalTableViewController: UITableViewController {

  var trainer: Trainer!
  fileprivate let tabsLabels = ["programs", "news"]
  fileprivate var selectedTab = 0
  var programs: Results<Program>!
  var news: Results<Post>!

  let trainersProvider = APIProvider<GetFit.Trainers>()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    news = trainer.posts.sorted(byKeyPath: "dateCreated")
    programs = trainer.programs.sorted(byKeyPath: "id")

    configureTableView()
    refresh()
  }

  func configureTableView() {
    let trainerInfoCellNib = UINib(nibName: String(describing: ProfessionalTableViewCell.self), bundle: nil)
    tableView.register(trainerInfoCellNib, forCellReuseIdentifier: "infoHeader")
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.register(ActionTableViewCell.self, forCellReuseIdentifier: "getPersonalTrainingCell")
    let postCellNib = UINib(nibName: String(describing: PostTableViewCell.self), bundle: nil)
    tableView.register(postCellNib, forCellReuseIdentifier: "postCell")
    tableView.register(cellType: ProgramTableViewCell.self)
    tableView.separatorStyle = .none

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
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
    trainersProvider.request(GetFit.Trainers.programs(trainerId: trainer.id)) { result in
      switch result {
      case .success(let response):
        self.programsResponseHandler(response, completion: completion)
      case .failure(let error):
        print(error)
        self.presentAlertWithMessage("\(error)")
      }
    }
  }

  fileprivate func programsResponseHandler(_ response: Response, completion: () -> Void) {
    do {
      try _ = response.filterSuccessfulStatusCodes()
      let programs = try response.map(to: [Program.self])

      let realm = try Realm()
      try realm.write {
        realm.add(programs, update: true)
      }

      completion()
    } catch let error {
      print(error)
      presentAlertWithMessage("\(error)")
    }
  }

  //MARK: - UITableViewDelegate && UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 2
    case 1 where selectedTab == 0:
      return programs.count
    case 1 where selectedTab == 1:
      return news.count
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0 where indexPath.row == 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoHeader") as? ProfessionalTableViewCell else {
        break
      }
      cell.configureWith(trainer, andState: .normal)
      return cell
    case 0 where indexPath.row == 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "getPersonalTrainingCell") as? ActionTableViewCell else {
        break
      }
      cell.title = "get personal training".uppercased()
      cell.delegate = self
      return cell
    case 1 where selectedTab == 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostTableViewCell else {
        break
      }
      let post = news[indexPath.row]
      cell.configureWith(PostViewModel(post: post))
      cell.displayAsPreview = true
      cell.state = .card
      cell.delegate = self

      return cell
    case 1 where selectedTab == 0:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ProgramTableViewCell
      cell.state = .card
      cell.configureWith(ProgramViewModel(program: programs[indexPath.row]))

      return cell
    default:
      break
    }

    return UITableViewCell()
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return nil
    case 1:
      let buttonStrip = ButtonsStripView(labels: tabsLabels)
      buttonStrip.delegate = self
      buttonStrip.selectedIndex = selectedTab

      return buttonStrip
    default:
      return nil
    }
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 50
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return indexPath.row == 0 ? 320 : 40
    case 1:
      return UITableViewAutomaticDimension
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return indexPath.row == 0 ? 350 : 40
    case 1:
      return 400
    default:
      return 0
    }
  }
}

extension ProfessionalTableViewController: ButtonStripViewDelegate {
  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedTab = index
//    let indexSet =
//    tableView.reloadSections(NSIndexSet(index: 1, index: 0), withRowAnimation: UITableViewRowAnimation.Top)
    let offset = tableView.contentOffset
    tableView.reloadData()
    if tableView.numberOfRows(inSection: selectedTab) >= 2 {
      tableView.setContentOffset(offset, animated: true)
    } else {
      tableView.setContentOffset(CGPoint.zero, animated: true)
    }
  }
}

extension ProfessionalTableViewController: ActionTableViewCellDelegate {
  func didSelectActionCell(_ cell: ActionTableViewCell) {
    presentAlertWithMessage("personal training")
  }
}

extension ProfessionalTableViewController: PostTableViewCellDelegate {
}
