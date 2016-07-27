import UIKit
import Moya
import RealmSwift
import Reusable

class ChatsTableViewController: UITableViewController {
  
  let subscriptionsProvider = APIProvider<GetFit.Subscriptions>()
  var subscriptions: Results<Subscription>!
  lazy var realm = try! Realm()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    subscriptions = realm.objects(Subscription.self).sorted("createdAt", ascending: true)
    
    configureTableView()
    
    title = "Chats"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(closeButtonAction(_:)))
    
    refresh()
  }
  
  private func configureTableView() {
    tableView.registerReusableCell(ChatsTableViewCell)
    
    tableView.backgroundColor = UIColor.whiteColor()
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , forControlEvents: .ValueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubviewToBack(refreshControl)
  }
  
  //MARK: - Refresh
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(completion: () -> Void) {
    subscriptionsProvider.request(.List) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          try self.updateDataWith(response)
        } catch let error {
          print(error)
        }
      case .Failure(let error):
        print(error)
      }
      
      completion()
    }
  }
  
  private func updateDataWith(response: Response) throws {
    let subscriptions = try response.mapArray(Subscription.self)
    try self.realm.write {
      self.realm.delete(self.realm.objects(Subscription.self))
      self.realm.add(subscriptions, update: true)
    }
  }
  
  
  //MARK: - Actions
  func closeButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - TableView
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subscriptions.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ChatsTableViewCell
    
    let subscription = subscriptions[indexPath.row]
    cell.configureWith(SubscriptionViewModel(subscription: subscription))
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let subscription = subscriptions[indexPath.row]
    let conversationViewController = ConversationViewController()
    conversationViewController.subscriptionsProvider = subscriptionsProvider
    conversationViewController.subscription = subscription
    
    navigationController?.pushViewController(conversationViewController, animated: true)
  }
  
}
