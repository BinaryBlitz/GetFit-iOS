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
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    setupKeyboard()
    setupTableView()
    
    commentFieldCard.layer.borderColor = UIColor.graySecondaryColor().colorWithAlphaComponent(0.2).CGColor
    commentFieldCard.layer.borderWidth = 1
    sendCommentButton.tintColor = UIColor.blueAccentColor()
    sendCommentButton.setTitle("Send", forState: .Normal)
  }
  
  override func viewDidAppear(animated: Bool) {
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
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                   name: UIKeyboardWillShowNotification, object: nil)
    
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),
                                   name: UIKeyboardWillHideNotification, object: nil)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
    view.addGestureRecognizer(tapGesture)
  }
  
  func setupTableView() {
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    tableView.tableFooterView = UIView()
    tableView.registerReusableCell(PostTableViewCell)
    tableView.registerReusableCell(PostCommentTableViewCell)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
    
    tableView.addInfiniteScrollingWithActionHandler {
      self.refresh()
    }
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
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
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    postsProvider.request(.GetComments(postId: post.id)) { (result) in
      switch result {
      case .Success(let response):
        
        do {
          try response.filterSuccessfulStatusCodes()
          let comments = try response.mapArray(Comment.self)
          
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
      case .Failure(let error):
        print("error in fetchComments: \(error)")
      }
      
      completion()
    }
  }
  
  //MARK: - Actions
  @IBAction func createCommentButtonAction(sender: AnyObject) {
    guard let content = commentTextField.text else { return }
    sendCommentButton.userInteractionEnabled = false
    let comment = Comment()
    comment.content = content
    comment.dateCreated = NSDate()
    comment.author = UserManager.currentUser
    
    postsProvider.request(.CreateComment(comment: comment, postId: post.id)) { (result) in
      self.sendCommentButton.userInteractionEnabled = true
      switch result {
      case .Success(_):
        self.commentTextField.text = nil
        self.refresh()
      case .Failure(let error):
        print(error)
        self.presentAlertWithMessage("Ну удалось отправить комментарий")
      }
    }
  }
  
  private func insert(comment: Comment, inSection section: Int) {
    guard tableView.numberOfSections >= 2 else { return }
    let lastRowIndex = tableView.numberOfRowsInSection(1)
    let indexPath = NSIndexPath(forRow: lastRowIndex, inSection: 1)
    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
  }
  
  @objc func showTrainerPage() {
    if post.trainer != nil {
      performSegueWithIdentifier("showTrainerPage", sender: self)
    } else {
      presentAlertWithMessage("Cannot load trainer")
    }
  }
  
  @objc func showProgramPage() {
    if post.program != nil {
      performSegueWithIdentifier("showProgramPage", sender: self)
    } else {
      presentAlertWithMessage("Cannot load program")
    }
  }
  
  @objc private func showImage() {
    let browser = MWPhotoBrowser(delegate: self)
    browser.setCurrentPhotoIndex(0)
    navigationController?.pushViewController(browser, animated: true)
  }
  
  //MARK: - Tools
  func reloadCommentsSection() {
    if tableView.numberOfSections >= 2 {
      tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
    }
  }
  
  func scrollToBottom() {
    let lastSection = tableView.numberOfSections - 1
    let lastRowInLastSection = tableView.numberOfRowsInSection(lastSection) - 1
    if lastRowInLastSection > 0 {
      let indexPath = NSIndexPath(forRow: lastRowInLastSection, inSection: lastSection)
      tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
  }
  
  //MARK: - Navigation 
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showTrainerPage" {
      let destination = segue.destinationViewController as! ProfessionalTableViewController
      destination.trainer = post.trainer!
    } else if segue.identifier == "showProgramPage" {
      let destination = segue.destinationViewController as! ProgramDetailsTableViewController
      destination.program = post.program
    }
    
  }
}

//MARK: - UITableViewDataSource
extension PostViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return post.comments.count
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let post = post else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(for: indexPath) as PostTableViewCell
      
      cell.configureWith(PostViewModel(post: post))
      cell.displayAsPreview = false
      cell.state = .Normal
      cell.delegate = self
      if let imageView = cell.contentImageView {
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImage)))
      }
      
      [cell.trainerNameLabel, cell.trainerAvatarImageView].forEach { view in
        view.userInteractionEnabled = true
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
  func didTouchLikeButton(cell: PostTableViewCell) {
    PostViewModel(post: post).updateReaction(cell.likeButton.selected ? .Like : .Dislike)
  }
}

// MARK: - MWPhotoBrowserDelegate
extension PostViewController: MWPhotoBrowserDelegate {
  
  func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
    return 1
  }
  
  func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
    guard let imageURLString = post.imageURLString, url = NSURL(string: imageURLString) else { return nil }
    
    return MWPhoto(URL: url)
  }
}

//MARK: - Keyboard events
extension PostViewController {
  
  func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
  
    let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
    let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
    let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
    let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
    keyboardHeight.constant = endFrame?.size.height ?? 0
    UIView.animateWithDuration(duration, delay: 0,
      options: animationCurve,
      animations: {
        self.view.layoutIfNeeded()
      },
      completion: { (_) -> Void in
        self.scrollToBottom()
      })
  }

  func keyboardWillHide(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {
      return
    }
    
    let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
    let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
    let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
    let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
    keyboardHeight.constant = 0
    UIView.animateWithDuration(duration, delay: 0, options: animationCurve,
        animations: { self.view.layoutIfNeeded() }, completion: nil)
  }

  func dismissKeyboard(sender: AnyObject) {
     view.endEditing(true)
  }
}
