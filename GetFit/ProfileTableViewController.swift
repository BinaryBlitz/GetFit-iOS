import UIKit
import Reusable
import RealmSwift
import Moya
import SwiftyJSON
import RSKImageCropper

class ProfileTableViewController: UITableViewController {

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

    let realm = try! Realm()
    programs = realm.objects(Program.self).filter("purchaseId != %@", -1)
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
          let userJSON = try response.mapJSON()
          let realm = try Realm()
          try realm.write {
            UserManager.currentUser?.map(jsonData: JSON(userJSON))
          }
          self.user = UserManager.currentUser
          self.loadPrograms()
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
    userProvider.request(.getStatistics(forUserWithId: user.id)) { [weak self] (result) in
      switch result {
      case .success(let response):
        do {
          let realm = try! Realm()
          try realm.write {
            user.statistics = try response.map(to: User.Statistics.self)
          }
          self?.tableView.reloadData()
        } catch {
          print("Cannot map response")
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  fileprivate func loadPrograms() {
    guard let user = user else { return }
    userProvider.request(.getPrograms()) { (result) in
      switch result {
      case .success(let response):
        do {
          let programs = try response.map(to: [Program.self])
          let realm = try Realm()
          try realm.write {
            realm.add(programs, update: true)
          }
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

  // MARK: - Actions
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

  // MARK: - Refresh
  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    loadUser(completion)
  }

  // MARK: - UITableViewDataSource
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
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

      cell.settingsButton.addTarget(self, action: #selector(settingsButtonAction(_:)), for: .touchUpInside)
      cell.avatarImageView.isUserInteractionEnabled = true
      let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.updateAvatar))
      cell.avatarImageView.addGestureRecognizer(avatarTapGesture)

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(for: indexPath) as ProgramTableViewCell
      cell.state = .card
      let program = programs![indexPath.row]
      cell.configureWith(ProgramViewModel(program: program))

      return cell
    default:
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return 180
    case 1:
      return 320
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == 1 else { return nil }

    let buttonStrip = ButtonsStripView(labels: ["programs".uppercased()])
    buttonStrip.selectedIndex = 0

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

// MARK: - UIImagePickerControllerDelegate

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
    picker.dismiss(animated: true, completion: nil)

    let imageCropViewController = RSKImageCropViewController(image: image)
    imageCropViewController.delegate = self
    present(imageCropViewController, animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

extension ProfileTableViewController: RSKImageCropViewControllerDelegate {
  func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
    controller.dismiss(animated: true, completion: nil)
    guard let imageType = imageTypeToSelect else { return }

    userProvider.request(.updateImage(type: imageType, image: croppedImage)) { (result) in
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

  func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
