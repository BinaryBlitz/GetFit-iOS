//
//  NewsTableViewController.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import Moya

class NewsTableViewController: UITableViewController {
  
  var posts: Results<Post>?
  let postsProvider = APIProvider<GetFit.Posts>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    fetchPosts()
    configureTableView()
    refresh()
  }
  
  private func configureTableView() {
    
    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    let postCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCell")
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCellWithImage")
    tableView.registerNib(postCellNib, forCellReuseIdentifier: "postCellWithProgram")
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
    headerView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.tableHeaderView = headerView
    
    tableView.backgroundView = EmptyStateHelper.backgroundViewFor(.News)
    
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
      self.fetchPosts()
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    postsProvider.request(.Index) { (result) in
      switch result {
      case .Success(let response):
        do {
          let postsResponse = try response.filterSuccessfulStatusCodes()
          let posts = try postsResponse.mapArray(Post.self)
          let realm = try! Realm()
          try realm.write {
            realm.add(posts, update: true)
          }
          
          completion()
        } catch {
          print("response is not successful")
          self.presentAlertWithMessage("Cannot update feed")
        }
      case .Failure(let error):
        print(error)
        self.presentAlertWithMessage("Oh, no!")
        completion()
      }
    }
  }
  
  //MARK: - UITableViewDataSource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = posts?.count ?? 0
    tableView.backgroundView?.hidden = numberOfRows != 0
    
    return numberOfRows
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let post = posts?[indexPath.row] else { return UITableViewCell() }
    
    let cell: PostTableViewCell
    
    if post.imageURLString != nil {
      cell = tableView.dequeueReusableCellWithIdentifier("postCellWithImage", forIndexPath: indexPath) as! PostTableViewCell
    } else if post.program != nil {
      cell = tableView.dequeueReusableCellWithIdentifier("postCellWithProgram", forIndexPath: indexPath) as! PostTableViewCell
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
    }
    
    cell.configureWith(PostViewModel(post: post))
    cell.displayAsPreview = true
    cell.state = .Card
    cell.delegate = self
    
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let post = posts![indexPath.row]
    
    if post.imageURLString != nil {
      return 400
    } else if post.program != nil {
      return 300
    } else {
      return UITableViewAutomaticDimension
    }
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let post = posts![indexPath.row]
    
    if post.imageURLString != nil {
      return 400
    } else if post.program != nil {
      return 300
    } else {
      return 180
    }
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
      destination.postsProvider = postsProvider
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
    let chatsViewController = ChatsTableViewController(style: .Plain)
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
  
  func didTouchLikeButton(cell: PostTableViewCell) {
    struct SharedRequest {
      static var request: Cancellable?
    }
    
    //FIXME: this is just wrong
    SharedRequest.request?.cancel()
    if let indexPath = tableView.indexPathForCell(cell),
        post = posts?[indexPath.row] {
      if cell.likeButton.selected {
        SharedRequest.request = postsProvider.request(.CreateLike(postId: post.id)) { result in
          switch result {
          case .Success(let response):
            do {
              try response.filterSuccessfulStatusCodes()
              print("yay! new like")
            } catch {
              cell.liked = false
            }
          case .Failure(let error):
            print(error)
            //TODO: add likes queue
          }
        }
      }
    }
  }
}
