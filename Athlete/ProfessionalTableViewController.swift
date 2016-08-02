import UIKit
import RealmSwift
import MWPhotoBrowser

class ProfessionalTableViewController: UITableViewController {
  
  var trainer: Trainer!
  private let tabsLabels = ["programs", "news"]
  private var selectedTab = 0
  var programms: Results<Program>?
  var news: Results<Post>!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    news = trainer.posts.sorted("dateCreated")
    configureTableView()
  }
  
  func configureTableView() {
    let trainerInfoCellNib = UINib(nibName: String(ProfessionalTableViewCell), bundle: nil)
    tableView.registerNib(trainerInfoCellNib, forCellReuseIdentifier: "infoHeader")
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.registerClass(ActionTableViewCell.self, forCellReuseIdentifier: "getPersonalTrainingCell")
    let postCellNib = UINib(nibName: String(PostTableViewCell), bundle: nil)
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCell")
    tableView.separatorStyle = .None
  }
  
  //MARK: - UITableViewDelegate && UITableViewDataSource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 2
    case 1 where selectedTab == 0:
      return 0
    case 1 where selectedTab == 1:
      return news.count
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0 where indexPath.row == 0:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("infoHeader") as? ProfessionalTableViewCell else {
        break
      }
      cell.configureWith(trainer, andState: .Normal)
      cell.avatarImageView.userInteractionEnabled = true
      cell.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAvatar)))
      
      cell.bannerImageView.userInteractionEnabled = true
      cell.bannerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBanner)))
      
      return cell
    case 0 where indexPath.row == 1:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("getPersonalTrainingCell") as? ActionTableViewCell else {
        break
      }
      cell.title = "get personal training".uppercaseString
      cell.delegate = self
      return cell
    case 1 where selectedTab == 0:
      break
    case 1 where selectedTab == 1:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostTableViewCell else {
        break
      }
      let post = news[indexPath.row]
      cell.configureWith(PostViewModel(post: post))
      cell.displayAsPreview = true
      cell.state = .Card
      cell.delegate = self
      
      return cell
    default:
      break
    }
    
    return UITableViewCell()
  }
  
  @objc private func showAvatar() {
    let browser = MWPhotoBrowser(delegate: self)
    browser.setCurrentPhotoIndex(0)
    navigationController?.pushViewController(browser, animated: true)
  }
  
  @objc private func showBanner() {
    let browser = MWPhotoBrowser(delegate: self)
    browser.setCurrentPhotoIndex(1)
    navigationController?.pushViewController(browser, animated: true)
  }

  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
      return 0
    case 1:
      return 50
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return indexPath.row == 0 ? 320 : 40
    case 1:
      return UITableViewAutomaticDimension
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
  func stripView(view: ButtonsStripView, didSelectItemAtIndex index: Int) {
    selectedTab = index
//    let indexSet = 
//    tableView.reloadSections(NSIndexSet(index: 1, index: 0), withRowAnimation: UITableViewRowAnimation.Top)
    let offset = tableView.contentOffset
    tableView.reloadData()
    if tableView.numberOfRowsInSection(selectedTab) >= 2 {
      tableView.setContentOffset(offset, animated: true)
    } else {
      tableView.setContentOffset(CGPoint.zero, animated: true)
    }
  }
}

extension ProfessionalTableViewController: ActionTableViewCellDelegate {
  func didSelectActionCell(cell: ActionTableViewCell) {
    presentAlertWithMessage("personal training")
  }
}

extension ProfessionalTableViewController: PostTableViewCellDelegate { }

//MARK: - MWPhotoBrowserDelegate
extension ProfessionalTableViewController: MWPhotoBrowserDelegate {
  
  func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
    return 2
  }
  
  func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
    let urlString: String?
    if index == 0 {
      urlString = trainer.avatarURLString
    } else {
      urlString = trainer.bannerURLString
    }
    
    guard let imageURLString = urlString, url = NSURL(string: imageURLString) else { return nil }
    
    return MWPhoto(URL: url)
  }
}
