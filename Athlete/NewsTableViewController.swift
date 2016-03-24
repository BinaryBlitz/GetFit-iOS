//
//  NewsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {
  
  var posts: Results<Post>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                       style: .Plain,
                                                       target: nil,
                                                       action: Selector(nilLiteral: ()))
    
    configureTableView()
    fetchPosts()
  }
  
  private func configureTableView() {
    
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    let postCellNib = UINib(nibName: String(PostTableViewCell), bundle: nil)
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCell")
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
    headerView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.tableHeaderView = headerView
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  func fetchPosts() {
    let realm = try! Realm()
    posts = realm.objects(Post).sorted("dateCreated", ascending: false)
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    delayFor(2) {
      completion()
    }
  }
  
  func delayFor(delay: Double, closure: () -> Void) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
  
  //MARK: - UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts?.count ?? 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostTableViewCell,
        post = posts?[indexPath.row] else {
      return UITableViewCell()
    }
    
    cell.configureWith(PostViewModel(post: post))
    cell.displayAsPreview = true
    cell.state = .Card
    cell.delegate = self
    
    return cell
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    guard let post = posts?[indexPath.row] else {
      return
    }
    
    performSegueWithIdentifier("viewPost", sender: post)
  }
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? PostViewController, post = sender as? Post {
      destination.post = post
      switch segue.identifier {
      case .Some("viewPostAndComment"):
        destination.shouldShowKeyboadOnOpen = true
      default:
        break
      }
    }
  }
  
  //MARK: - IBActions
  
  @IBAction func chatsButtonAction(sender: AnyObject) {
    let chatsViewController = ChatsTableViewController()
    let navigationController = UINavigationController(rootViewController: chatsViewController)
    presentViewController(navigationController, animated: true, completion: nil)
  }
}

//MARK: - PostTableViewCellDelegate

extension NewsTableViewController: PostTableViewCellDelegate {
  
  func didTouchCommentButton(cell: PostTableViewCell) {
    guard let row = tableView.indexPathForCell(cell)?.row, post = posts?[row] else {
      return
    }
    
    performSegueWithIdentifier("viewPostAndComment", sender: post)
  }
}
