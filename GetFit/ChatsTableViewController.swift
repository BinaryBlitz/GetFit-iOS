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
    
    subscriptions = realm.objects(Subscription.self).sorted(byKeyPath: "createdAt", ascending: true)
    
    configureTableView()
    
    title = "Chats"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.leftBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonAction(_:)))
    
    refresh()
  }
  
  fileprivate func configureTableView() {
    tableView.register(cellType: ChatsTableViewCell.self)
    
    tableView.backgroundColor = UIColor.white
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)) , for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }
  
  //MARK: - Refresh
  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }
  
  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    subscriptionsProvider.request(.list) { (result) in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          try self.updateDataWith(response)
        } catch let error {
          print(error)
        }
      case .failure(let error):
        print(error)
      }
      
      completion()
    }
  }
  
  fileprivate func updateDataWith(_ response: Response) throws {
    let subscriptions = try response.map(to: [Subscription.self])
    try self.realm.write {
      self.realm.delete(self.realm.objects(Subscription.self))
      self.realm.add(subscriptions, update: true)
    }
  }
  
  
  //MARK: - Actions
  func closeButtonAction(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
  
  //MARK: - TableView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subscriptions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath) as ChatsTableViewCell
    
    let subscription = subscriptions[indexPath.row]
    cell.configureWith(SubscriptionViewModel(subscription: subscription))
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let subscription = subscriptions[indexPath.row]
    let conversationViewController = ConversationViewController()
    conversationViewController.subscriptionsProvider = subscriptionsProvider
    conversationViewController.subscription = subscription
    
    navigationController?.pushViewController(conversationViewController, animated: true)
  }
  
}
