import UIKit
import JSQMessagesViewController
import RealmSwift
import Moya
import Kingfisher

class ConversationViewController: JSQMessagesViewController {
  
  var subscription: Subscription!
  var messages = [JSQMessage]()
  var incomingBubble: JSQMessagesBubbleImage!
  var outgoingBubble: JSQMessagesBubbleImage!
  var subscriptionsProvider: APIProvider<GetFit.Subscriptions>!
  var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = subscription.trainer.name
    
    senderId = Message.Category.User.rawValue
    senderDisplayName = ""
    
    inputToolbar.contentView.leftBarButtonItem = nil
    
    configureChatViews()
    addAvatarToNavigationBar()
    reloadMessages()
    scrollToBottom(animated: true)
    
    NotificationCenter.default.addObserver(self, selector: #selector(refresh),
                                                     notification: .ReloadMessages)
    
    self.timer = Timer.scheduledTimer(
      timeInterval: 10,
      target: self,
      selector: #selector(refresh(_:)),
      userInfo: nil,
      repeats: true
    )
  }
  
  fileprivate func addAvatarToNavigationBar() {
    guard let imageURL = SubscriptionViewModel(subscription: subscription).avatarImageURL else { return }
    
    let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    let imageView = UIImageView(frame: CGRect(x: 7, y: 0, width: 37, height: 37))
    imageView.kf.setImage(with: imageURL)
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = imageView.frame.width / 2
    imageView.layer.shouldRasterize = true
    imageView.clipsToBounds = true
    contentView.addSubview(imageView)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentView)
  }
  
  fileprivate func configureChatViews() {
    collectionView.backgroundColor = UIColor.white
    incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.incomingMessageColor())
    outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.blueAccentColor())
    
    collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
    collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
    collectionView?.collectionViewLayout.springinessEnabled = true
    
    automaticallyScrollsToMostRecentMessage = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    timer?.fire()
    refresh()
  }

  override func viewDidDisappear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  deinit {
    timer?.invalidate()
  }
  
  //MARK: - Refresh
  
  func refresh(_ sender: AnyObject? = nil) {
    beginRefreshWithcompletion { () -> Void in
      self.collectionView?.reloadData()
      self.collectionView?.layoutIfNeeded()
      self.finishReceivingMessage(animated: true)
    }
  }
  
  func beginRefreshWithcompletion(_ completion: () -> Void) {
    subscriptionsProvider.request(GetFit.Subscriptions.listMessages(subscriptionId: subscription.id)) { (result) in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          try self.updateMessagesWith(response)
        } catch let error {
          print(error)
          self.presentAlertWithMessage("Try again later")
        }
      case .failure(let error):
        print(error)
        self.presentAlertWithMessage("Check your internet connection")
      }
    }
  }
  
  fileprivate func updateMessagesWith(_ response: Response) throws {
    let messages = try response.map(to: [Message.self])
    let realm = try Realm()
    try realm.write {
      self.subscription.messages.removeAll()
      self.subscription.messages.append(objectsIn: messages)
    }
    self.reloadMessages()
  }
  
  func reloadMessages() {
    messages = subscription.messages.sorted(byKeyPath: "createdAt").map { message -> JSQMessage in
      return JSQMessage(senderId: message.category?.rawValue, senderDisplayName: "", date: message.createdAt as Date, text: message.content)
    }
    collectionView?.reloadData()
  }
  
  // MARK: JSQMessagesViewController method overrides
  
  override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
    let message = Message()
    message.content = text
    message.category = .User
    
    subscriptionsProvider.request(.createMessage(subscriptionId: subscription.id, message: message)) { (result) in
      switch result  {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          let message = try response.map(to: Message.self)
          let realm = try! Realm()
          try! realm.write {
            self.subscription.messages.append(message)
          }
          self.reloadMessages()
          self.scrollToBottom(animated: true)
        } catch let error {
          print(error)
          self.presentAlertWithMessage("Cannot send your message")
        }
      case .failure(let error):
        print(error)
        self.presentAlertWithMessage("Cannot send your message. Check your internet conneciton")
      }
    
      self.reloadMessages()
      self.finishSendingMessage(animated: true)
    }
  }
  
  //MARK: JSQMessages CollectionView DataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    
    let message = messages[indexPath.item]
    
    if message.senderId == self.senderId {
      cell.textView!.textColor = UIColor.white
    } else {
      cell.textView!.textColor = UIColor.black
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource? {
    return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
    return messages[indexPath.item]
  }
  
}
