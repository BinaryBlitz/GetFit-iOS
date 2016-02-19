//
//  NewsPostViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class NewsPostViewController: UIViewController {
  
  let comments: [(String, Double)] = [("comment1", 6.78), ("comment2", 4.92)]
  var post: (String, Double)!

  @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpKeyboard()
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
  }

  func setUpKeyboard() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
    notificationCenter.addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard:"))
  }
  
  func scrollToBottom() {
    let numberOfRows = tableView.numberOfRowsInSection(1)
    let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: 1)
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
  }

  //MARK: - Keyboard events
  func keyboardWillShow(notification: NSNotification) {
      if let userInfo = notification.userInfo {
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
  }

  func keyboardWillHide(notification: NSNotification) {
      if let userInfo = notification.userInfo {
          _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
          let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
          let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
          let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
          let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
          keyboardHeight.constant = 0
          UIView.animateWithDuration(duration, delay: 0, options: animationCurve,
              animations: { self.view.layoutIfNeeded() }, completion: nil)
      }
  }

  func dismissKeyboard(sender: AnyObject) {
     view.endEditing(true)
  }
}

extension NewsPostViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0 :
      return 1
    default:
      return comments.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostTableViewCell else {
        return UITableViewCell()
      }
      
//      cell.contentImageView.image = UIImage(named: post.0)
      
      return cell
    case 1:
      let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
      
      if let imageView = cell.viewWithTag(1) as? UIImageView {
        imageView.image = UIImage(named: comments[indexPath.row].0)
      }
      
      return cell
    default:
      return UITableViewCell()
    }
  }
}

extension NewsPostViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      let width = tableView.frame.width - 16
      return width / CGFloat(post.1)
    default:
      let width = tableView.frame.width - 16
      return width / CGFloat(comments[indexPath.row].1)
    }
  }
}
