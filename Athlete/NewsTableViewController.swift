//
//  NewsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
  
  let posts: [Post] = [
    Post(),
    Post(),
    Post()
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
    
    configureTableView()
  }
  
  private func configureTableView() {
    
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    let postCellNib = UINib(nibName: String(PostTableViewCell), bundle: nil)
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCell")
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 400
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
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
    return posts.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostTableViewCell else {
      return UITableViewCell()
    }
    
    cell.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    return cell
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("did select row at index path")
  }
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if let destination = segue.destinationViewController as? NewsPostViewController,
//          postIndexPath = sender as? NSIndexPath
//          where segue.identifier == "post" {
//      destination.post = posts[postIndexPath.row].content
//    }
  }
}
