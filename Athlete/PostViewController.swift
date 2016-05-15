//
//  PostViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
import Reusable

class PostViewController: UIViewController {

  var post: Post!
  
  @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var commentFieldCard: UIView!
  @IBOutlet weak var sendCommentButton: UIButton!
  
  var shouldShowKeyboadOnOpen = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupKeyboard()
    setupTableView()
    
    commentFieldCard.layer.borderColor = UIColor.graySecondaryColor().colorWithAlphaComponent(0.2).CGColor
    commentFieldCard.layer.borderWidth = 1
    sendCommentButton.tintColor = UIColor.blueAccentColor()
    sendCommentButton.setTitle("Send", forState: .Normal)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if shouldShowKeyboadOnOpen {
      commentTextField.becomeFirstResponder()
      shouldShowKeyboadOnOpen = false
    }
    
    fetchComments()
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
  }
  
  //MARK: - Server stuff
  
  func fetchComments() {
    ServerManager.sharedManager.commentsFotPostWithId(post.id) { response in
      switch response.result {
      case .Success(let comments):
        
        // save comments
        let realm = try! Realm()
        try! realm.write {
          self.post.comments.removeAll()
          realm.add(comments, update: true)
          comments.forEach { comment in
            self.post.comments.append(comment)
          }
        }
        
        self.reloadCommentsSection()
      case .Failure(let error):
        print("error in fetchComments: \(error)")
      }
    }
  }
  
  //MARK: - Actions
  
  @IBAction func createCommentButtonAction(sender: AnyObject) {
    guard let content = commentTextField.text else { return }
    sendCommentButton.userInteractionEnabled = false
    let comment = Comment()
    comment.content = content
    ServerManager.sharedManager.createComment(comment, forPostWithId: post.id) { (response) in
      self.sendCommentButton.userInteractionEnabled = true
      switch response.result {
      case .Success(_):
        self.commentTextField.text = nil
        self.fetchComments()
      case .Failure(let error):
        print(error)
        self.presentAlertWithMessage("Ну удалось отправить комментарий")
      }
    }
  }
  
  //MARK: - Tools
  
  func reloadCommentsSection() {
    tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
  }
  
  func scrollToBottom() {
    let numberOfRows = tableView.numberOfRowsInSection(1)
    let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: 1)
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
  }
}

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
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as PostTableViewCell
      
      cell.configureWith(PostViewModel(post: post))
      cell.displayAsPreview = false
      cell.state = .Normal
      
      return cell
    case 1:
      guard let comment = post?.comments[indexPath.row] else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(indexPath: indexPath) as PostCommentTableViewCell
      
      cell.configureWith(CommentViewModel(comment: comment))
      
      return cell
    default:
      return UITableViewCell()
    }
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


