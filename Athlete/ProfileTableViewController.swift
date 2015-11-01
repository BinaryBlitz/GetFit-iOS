//
//  ProfileTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 01/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

  let news = [("ProfileTitle", 1.138), ("Stat", 0.7)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    
    tableView.separatorStyle = .None
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 3))
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    navigationController?.navigationBarHidden = true
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") else {
      return UITableViewCell()
    }
    
    cell.selectionStyle = .None
    if let imageView = cell.viewWithTag(1) as? UIImageView {
      imageView.image = UIImage(named: news[indexPath.row].0)
    }
    cell.backgroundColor = UIColor.lightGrayBackgroundColor()
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let width = tableView.frame.width
    
    return width / CGFloat(news[indexPath.row].1)
  }
}
