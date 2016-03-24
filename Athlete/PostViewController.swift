//
//  PostViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift

class PostViewController: UIViewController {

  var post: Post?
  
  @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var commentTextField: UITextField!
  
  var shouldShowKeyboadOnOpen = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpKeyboard()
    setUpTableView()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if shouldShowKeyboadOnOpen {
      commentTextField.becomeFirstResponder()
      shouldShowKeyboadOnOpen = false
    }
  }

  func setUpKeyboard() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),
                                   name: UIKeyboardWillShowNotification, object: nil)
    
    notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),
                                   name: UIKeyboardWillHideNotification, object: nil)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
    view.addGestureRecognizer(tapGesture)
  }
  
  func setUpTableView() {
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    let postCellNib = UINib(nibName: String(PostTableViewCell), bundle: nil)
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCell")
    let commentCellNib = UINib(nibName: String(PostCommentTableViewCell), bundle: nil)
    tableView.registerNib(commentCellNib, forCellReuseIdentifier: "commentCell")
  }
  
  func scrollToBottom() {
    let numberOfRows = tableView.numberOfRowsInSection(1)
    let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: 1)
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
  }

  //MARK: - Keyboard events
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
//        self.scrollToBottom()
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

extension PostViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return post?.comments.count ?? 0
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostTableViewCell,
          post = post else {
        return UITableViewCell()
      }
      
      cell.configureWith(PostViewModel(post: post))
      cell.displayAsPreview = false
      
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as? PostCommentTableViewCell,
          comment = post?.comments[indexPath.row] else {
        return UITableViewCell()
      }
      
      cell.configureWith(CommentViewModel(comment: comment))
      
      return cell
    default:
      return UITableViewCell()
    }
  }
}


