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
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    fetchPosts()
    configureTableView()
    refresh()
  }

  fileprivate func configureTableView() {

    tableView.backgroundColor = UIColor.lightGrayBackgroundColor()
    let postCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
    tableView.register(postCellNib, forCellReuseIdentifier: "postCell")
    tableView.register(postCellNib, forCellReuseIdentifier: "postCellWithImage")
    tableView.register(postCellNib, forCellReuseIdentifier: "postCellWithProgram")

    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 14))
    headerView.backgroundColor = UIColor.lightGrayBackgroundColor()
    tableView.tableHeaderView = headerView

    tableView.backgroundView = EmptyStateHelper.backgroundViewFor(.news)

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    refreshControl.backgroundColor = UIColor.lightGrayBackgroundColor()
    self.refreshControl = refreshControl
    tableView.addSubview(refreshControl)
    tableView.sendSubview(toBack: refreshControl)
  }

  func fetchPosts() {
    let realm = try! Realm()
    posts = realm.objects(Post.self).sorted(byKeyPath: "dateCreated", ascending: false)
  }

  // MARK: - Refresh

  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithCompletion {
      self.fetchPosts()
      self.tableView.reloadData()
      self.refreshControl?.endRefreshing()
    }
  }

  func beginRefreshWithCompletion(_ completion: @escaping () -> Void) {
    postsProvider.request(.index) { (result) in
      switch result {
      case .success(let response):
        do {
          let postsResponse = try response.filterSuccessfulStatusCodes()
          let posts = try postsResponse.map(to: [Post.self])
          let realm = try! Realm()
          try realm.write {
            realm.add(posts, update: true)
          }

          completion()
        } catch {
          print("response is not successful")
          self.presentAlertWithMessage("Cannot update feed")
        }
      case .failure(let error):
        print(error)
        self.presentAlertWithMessage("Oh, no!")
        completion()
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = posts?.count ?? 0
    tableView.backgroundView?.isHidden = numberOfRows != 0

    return numberOfRows
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let post = posts?[indexPath.row] else { return UITableViewCell() }

    let cell: PostTableViewCell

    if post.imageURLString != nil {
      cell = tableView.dequeueReusableCell(withIdentifier: "postCellWithImage", for: indexPath) as! PostTableViewCell
    } else if post.program != nil {
      cell = tableView.dequeueReusableCell(withIdentifier: "postCellWithProgram", for: indexPath) as! PostTableViewCell
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
    }

    cell.configureWith(PostViewModel(post: post))
    cell.displayAsPreview = true
    cell.state = .card
    cell.delegate = self

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let post = posts![indexPath.row]

    if post.imageURLString != nil {
      return 400
    } else if post.program != nil {
      return 300
    } else {
      return UITableViewAutomaticDimension
    }
  }

  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let post = posts![indexPath.row]

    if post.imageURLString != nil {
      return 400
    } else if post.program != nil {
      return 300
    } else {
      return 180
    }
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let post = posts?[indexPath.row] else {
      return
    }

    performSegue(withIdentifier: "viewPost", sender: post)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? PostViewController, let post = sender as? Post {
      destination.post = post
      destination.postsProvider = postsProvider
      switch segue.identifier {
      case .some("viewPostAndComment"):
        destination.shouldShowKeyboadOnOpen = true
      default:
        break
      }
    }
  }

  // MARK: - IBActions

  @IBAction func chatsButtonAction(_ sender: AnyObject) {
    let chatsViewController = ChatsTableViewController(style: .plain)
    let navigationController = UINavigationController(rootViewController: chatsViewController)
    present(navigationController, animated: true, completion: nil)
  }

}

// MARK: - PostTableViewCellDelegate

extension NewsTableViewController: PostTableViewCellDelegate {

  func didTouchCommentButton(_ cell: PostTableViewCell) {
    guard let row = tableView.indexPath(for: cell)?.row, let post = posts?[row] else {
      return
    }

    performSegue(withIdentifier: "viewPostAndComment", sender: post)
  }

  func didTouchLikeButton(_ cell: PostTableViewCell) {

    struct SharedRequest {
      static var request: Cancellable?
    }

    SharedRequest.request?.cancel()
    guard let indexPath = tableView.indexPath(for: cell), let post = posts?[indexPath.row] else { return }
    SharedRequest.request =
      PostViewModel(post: post).updateReaction(cell.likeButton.isSelected ? .like : .dislike)
  }
}
