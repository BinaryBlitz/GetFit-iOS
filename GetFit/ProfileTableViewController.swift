import UIKit
import Reusable
import RealmSwift
import Moya

class ProfileTableViewController: UITableViewController {

  fileprivate let tabsLabels = ["statistic", "programs"]
  fileprivate var selectedTabIndex = 0
  fileprivate var imageTypeToSelect: Image?
  let userProvider = APIProvider<GetFit.Users>()

  var programs: Results<Program>?
  var user: User? {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    loadUser()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    setupTableView()

    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(ProfileTableViewController.refresh(_:)), for
    : UIControlEvents.valueChanged)

//    let realm = try! Realm()
//    programs = realm.objects(Program)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadUser()
  }

  fileprivate func loadUser(_ completion: (() -> Void)? = nil) {
    if let user = UserManager.currentUser {
      self.user = user
    }

    userProvider.request(.getCurrent) { (result) in
      switch result {
      case .success(let response):
        do {
          let user = try response.map(to: User.self)
          UserManager.currentUser = user
          self.user = user
          self.loadStatistics()
        } catch {
          print("kek")
        }
      case .failure(let error):
        print(error)
        break
      }
    }
    completion?()
  }

  fileprivate func loadStatistics() {
    guard let user = user else { return }
    userProvider.request(.getStatistics(forUserWithId: user.id)) { (result) in
      switch result {
      case .success(let response):
        do {
          user.statistics = try response.map(to: User.Statistics.self)
          self.user = user
        } catch {
          print("Cannot map response")
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  fileprivate func setupTableView() {
    tableView.register(cellType: ProfileCardTableViewCell.self)
    tableView.register(cellType: ProgramTableViewCell.self)
    tableView.register(cellType: StatisticsTableViewCell.self)

    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }

  //MARK: - Actions
  func updateAvatar() {
    update(.Avatar)
  }

  func updateBanner() {
    update(.Banner)
  }

  fileprivate func update(_ image: Image) {
    let title = "Update \(image.rawValue.lowercased())"
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Choose from library", style: .default, handler: { (action) in
      self.presentImagePickerWithImagesFrom(.photoLibrary, toUpdate: image)
    }))
    alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { (action) in
      self.presentImagePickerWithImagesFrom(.camera, toUpdate: image)
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }

  func presentImagePickerWithImagesFrom(_ sourceType: UIImagePickerControllerSourceType, toUpdate image: Image) {
    self.imageTypeToSelect = image
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = sourceType
    present(imagePicker, animated: true, completion: nil)
  }

  //MARK: - Refresh
  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    loadUser(completion)
  }

  //MARK: - UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1 where selectedTabIndex == 0:
      return 1
    case 1 where selectedTabIndex == 1:
      if let programs = programs {
        return programs.count
      } else {
        return 0
      }
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ProfileCardTableViewCell
      if let user = user {
        cell.configureWith(UserViewModel(user: user))
      }

      let button = UIButton()
      button.addTarget(self, action: #selector(settingsButtonAction(_:)), for: .touchUpInside)
      cell.settingsBadge.addSubview(button)
      button.autoPinEdgesToSuperviewEdges()

      cell.avatarImageView.isUserInteractionEnabled = true
      let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.updateAvatar))
      cell.avatarImageView.addGestureRecognizer(avatarTapGesture)

      cell.bannerImageView.isUserInteractionEnabled = true
      let bannerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.updateBanner))
      cell.bannerImageView.addGestureRecognizer(bannerTapGesture)

      return cell
    case 1 where selectedTabIndex == 0:
      let cell = tableView.dequeueReusableCell(for: indexPath) as StatisticsTableViewCell
      cell.layoutSubviews()
      if let user = user {
        cell.configureWith(UserViewModel(user: user))
      }

      return cell
    case 1 where selectedTabIndex == 1:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ProgramTableViewCell
      cell.state = .card
      let program = programs![indexPath.row]
      cell.configureWith(ProgramViewModel(program: program))

      return cell
    default:
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if let statistics = cell as? StatisticsTableViewCell {
      statistics.layoutSubviews()
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    if selectedTabIndex == 0 {
      let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
      cell?.layoutSubviews()
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 230
    case 1 where selectedTabIndex == 0:
      return tableView.frame.width
    case 1 where selectedTabIndex == 1:
      return 320
    default:
      return 0
    }
  }

  //MARK: - UITableViewDelegate

  //MARK: - Header configuration

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 1 else { return nil }

    let labels = tabsLabels.map { $0.uppercased() }
    let buttonStrip = ButtonsStripView(labels: labels)
    buttonStrip.delegate = self
    buttonStrip.selectedIndex = selectedTabIndex

    return buttonStrip
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard section == 1 else { return 0 }
    return 50
  }

  func settingsButtonAction(_ sender: UIButton) {
    performSegue(withIdentifier: "settings", sender: nil)
  }
}

//MARK: - UIImagePickerControllerDelegate

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
    guard let imageType = imageTypeToSelect else { return }
    picker.dismiss(animated: true, completion: nil)

    userProvider.request(.updateImage(type: imageType, image: image)) { (result) in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          self.presentAlertWithMessage("\(imageType.rawValue) updated!")
          self.refresh()
        } catch {
          print("response is not successful")
          self.presentAlertWithMessage("Upload failed")
        }
      case .failure(let error):
        print("error: \(error)")
        self.presentAlertWithMessage("Error: \(error)")
      }
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

extension ProfileTableViewController: ButtonStripViewDelegate {

  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedTabIndex = index
    let offset = tableView.contentOffset
    tableView.reloadData()
    if tableView.numberOfRows(inSection: index) >= 2 {
      tableView.setContentOffset(offset, animated: true)
    } else {
      tableView.setContentOffset(CGPoint.zero, animated: true)
    }
  }
}
