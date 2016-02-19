//
//  NewsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

  let news = [("news1", 0.9), ("news2", 1.4), ("news3", 0.9), ("news4", 1.3)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: "")
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 16))
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    let postCellNib = UINib(nibName: String(PostTableViewCell), bundle: nil)
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCell")
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostTableViewCell else {
      return UITableViewCell()
    }
    
    cell.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let width = tableView.frame.width - 16
    
    return width / CGFloat(news[indexPath.row].1)
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("post", sender: indexPath)
  }
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? NewsPostViewController,
          postIndexPath = sender as? NSIndexPath
          where segue.identifier == "post" {
      destination.post = news[postIndexPath.row]
    }
  }
}
