import UIKit
import RealmSwift
import Reusable
import MWPhotoBrowser
import SVPullToRefresh

class PostViewController: UIViewController {

  var post: Post!
  var postsProvider: APIProvider<GetFit.Posts>!
  
  var refreshControl: UIRefreshControl!
  
  @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var commentFieldCard: UIView!
  @IBOutlet weak var sendCommentButton: UIButton!
  
  var shouldShowKeyboadOnOpen = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    setupKeyboard()
    setupTableView()
    
    commentFieldCard.layer.borderColor = UIColor.graySecondaryColor().withAlphaComponent(0.2).cgColor
    commentFieldCard.layer.borderWidth = 1
    sendCommentButton.tintColor = UIColor.blueAccentColor()
    sendCommentButton.setTitle("Send", for: UIControlState())
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    tableView.reloadData()
    
    if shouldShowKeyboadOnOpen {
      commentTextField.becomeFirstResponder()
      shouldShowKeyboadOnOpen = false
    }
    
    refresh()
  }
  
  //MARK: - Setup methods
  func setupKeyboard() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                   name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),
                                   name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
    view.addGestureRecognizer(tapGesture)
  }
  
  func setupTableView() {
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    tableView.tableFooterView = UIView()
    tableView.register(cellType: PostTableViewCell.self)
    tableView.register(cellType: PostCommentTableViewCell.self)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
    
    tableView.addInfiniteScrolling {
      self.refresh()
    }
  }
  
  //MARK: - Refresh
  
  func refresh(_ sender: AnyObject? = nil) {
    let oldCommentsCount = post.comments.count
    beginRefreshWithCompletion {
      if oldCommentsCount != self.post.comments.count {
        self.tableView.reloadData()
        self.reloadCommentsSection()
      }
      self.refreshControl?.endRefreshing()
      self.tableView.infiniteScrollingView.stopAnimating()
      self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
  
  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    postsProvider.request(.getComments(postId: post.id)) { (result) in
      switch result {
      case .success(let response):
        
        do {
          try _ = response.filterSuccessfulStatusCodes()
          let comments = try response.map(to: [Comment.self])
          
          let realm = try Realm()
          try realm.write {
            self.post.comments.removeAll()
            realm.add(comments, update: true)
            comments.forEach { comment in
              self.post.comments.append(comment)
            }
          }
        } catch {
          print("Cannot load comments")
        }
      case .failure(let error):
        print("error in fetchComments: \(error)")
      }
      
      completion()
    }
  }
  
  //MARK: - Actions
  @IBAction func createCommentButtonAction(_ sender: AnyObject) {
    guard let content = commentTextField.text else { return }
    sendCommentButton.isUserInteractionEnabled = false
    let comment = Comment()
    comment.content = content
    comment.dateCreated = Date()
    comment.author = UserManager.currentUser
    
    postsProvider.request(.createComment(comment: comment, postId: post.id)) { (result) in
      self.sendCommentButton.isUserInteractionEnabled = true
      switch result {
      case .success(_):
        self.commentTextField.text = nil
        self.refresh()
      case .failure(let error):
        print(error)
        self.presentAlertWithMessage("Ну удалось отправить комментарий")
      }
    }
  }
  
  fileprivate func insert(_ comment: Comment, inSection section: Int) {
    guard tableView.numberOfSections >= 2 else { return }
    let lastRowIndex = tableView.numberOfRows(inSection: 1)
    let indexPath = IndexPath(row: lastRowIndex, section: 1)
    tableView.insertRows(at: [indexPath], with: .bottom)
    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
  }
  
  @objc func showTrainerPage() {
    if post.trainer != nil {
      performSegue(withIdentifier: "showTrainerPage", sender: self)
    } else {
      presentAlertWithMessage("Cannot load trainer")
    }
  }
  
  @objc func showProgramPage() {
    if post.program != nil {
      performSegue(withIdentifier: "showProgramPage", sender: self)
    } else {
      presentAlertWithMessage("Cannot load program")
    }
  }
  
  @objc fileprivate func showImage() {
    let browser = MWPhotoBrowser(delegate: self)
    browser?.setCurrentPhotoIndex(0)
    navigationController?.pushViewController(browser!, animated: true)
  }
  
  //MARK: - Tools
  func reloadCommentsSection() {
    if tableView.numberOfSections >= 2 {
      tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
  }
  
  func scrollToBottom() {
    let lastSection = tableView.numberOfSections - 1
    let lastRowInLastSection = tableView.numberOfRows(inSection: lastSection) - 1
    if lastRowInLastSection > 0 {
      let indexPath = IndexPath(row: lastRowInLastSection, section: lastSection)
      tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }
  
  //MARK: - Navigation 
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showTrainerPage" {
      let destination = segue.destination as! ProfessionalTableViewController
      destination.trainer = post.trainer!
    } else if segue.identifier == "showProgramPage" {
      let destination = segue.destination as! ProgramDetailsTableViewController
      destination.program = post.program
    }
    
  }
}

//MARK: - UITableViewDataSource
extension PostViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return post.comments.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let post = post else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
      
      cell.configureWith(PostViewModel(post: post))
      cell.displayAsPreview = false
      cell.state = .normal
      cell.delegate = self
      if let imageView = cell.contentImageView {
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImage)))
      }

      let interactiveViews: [UIView] = [cell.trainerNameLabel, cell.trainerAvatarImageView]
      
      interactiveViews.forEach { view in
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTrainerPage)))
      }
      
      if post.program != nil {
        cell.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProgramPage)))
      }
      
      return cell
    case 1:
      guard let comment = post?.comments[indexPath.row] else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(for: indexPath) as PostCommentTableViewCell
      
      cell.configureWith(CommentViewModel(comment: comment))
      
      return cell
    default:
      return UITableViewCell()
    }
  }
  
}

// MARK: - PostTableViewCellDelegate 
extension PostViewController: PostTableViewCellDelegate {
  func didTouchLikeButton(_ cell: PostTableViewCell) {
    _ = PostViewModel(post: post).updateReaction(cell.likeButton.isSelected ? .like : .dislike)
  }
}

// MARK: - MWPhotoBrowserDelegate
extension PostViewController: MWPhotoBrowserDelegate {
  
  func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
    return 1
  }
  
  func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
    guard let imageURLString = post.imageURLString, let url = URL(string: imageURLString) else { return nil }
    
    return MWPhoto(url: url)
  }
}

//MARK: - Keyboard events
extension PostViewController {
  
  func keyboardWillShow(_ notification: Foundation.Notification) {
    guard let userInfo = notification.userInfo else {
      return
    }
  
    let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
    let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
    let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
    let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
    keyboardHeight.constant = endFrame?.size.height ?? 0
    UIView.animate(withDuration: duration, delay: 0,
      options: animationCurve,
      animations: {
        self.view.layoutIfNeeded()
      },
      completion: { (_) -> Void in
        self.scrollToBottom()
      })
  }

  func keyboardWillHide(_ notification: Foundation.Notification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    
    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
    let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
    let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
    let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
    keyboardHeight.constant = 0
    UIView.animate(withDuration: duration, delay: 0, options: animationCurve,
        animations: { self.view.layoutIfNeeded() }, completion: nil)
  }

  func dismissKeyboard(_ sender: AnyObject) {
     view.endEditing(true)
  }
}
