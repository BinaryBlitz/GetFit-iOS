import UIKit
import JSQMessagesViewController
import RealmSwift
import Moya

let ReloadMessagesNotification = "ReloadMessagesNotification"

class ConversationViewController: JSQMessagesViewController {
  
  var subscription: Subscription!
  var messages = [JSQMessage]()
  var incomingBubble: JSQMessagesBubbleImage!
  var outgoingBubble: JSQMessagesBubbleImage!
  var subscriptionsProvider: APIProvider<GetFit.Subscriptions>!
  var timer: NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = subscription.trainer.name
    
    senderId = Message.Category.User.rawValue
    senderDisplayName = ""
    
    inputToolbar.contentView.leftBarButtonItem = nil
    
    configureChatViews()
    reloadMessages()
    scrollToBottomAnimated(true)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refresh(_:)),
            name: ReloadMessagesNotification, object: nil)
    
    self.timer = NSTimer.scheduledTimerWithTimeInterval(
      10,
      target: self,
      selector: #selector(refresh(_:)),
      userInfo: nil,
      repeats: true
    )
  }
  
  private func configureChatViews() {
    collectionView.backgroundColor = UIColor.lightGrayBackgroundColor()
    incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.whiteColor())
    outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.blueAccentColor())
    
    collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
    collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
    collectionView?.collectionViewLayout.springinessEnabled = true
    
    automaticallyScrollsToMostRecentMessage = true
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    timer?.fire()
    refresh()
  }

  override func viewDidDisappear(animated: Bool) {
    timer?.invalidate()
  }
  
  deinit {
    timer?.invalidate()
  }
  
  //MARK: - Refresh
  
  func refresh(sender: AnyObject? = nil) {
    beginRefreshWithcompletion { () -> Void in
      self.collectionView?.reloadData()
      self.collectionView?.layoutIfNeeded()
      self.finishReceivingMessageAnimated(true)
    }
  }
  
  func beginRefreshWithcompletion(completion: () -> Void) {
    subscriptionsProvider.request(GetFit.Subscriptions.ListMessages(subscriptionId: subscription.id)) { (result) in
      switch result {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          try self.updateMessagesWith(response)
        } catch let error {
          print(error)
          self.presentAlertWithMessage("Try again later")
        }
      case .Failure(let error):
        print(error)
        self.presentAlertWithMessage("Check your internet connection")
      }
    }
  }
  
  private func updateMessagesWith(response: Response) throws {
    let messages = try response.mapArray(Message.self)
    let realm = try Realm()
    try realm.write {
      self.subscription.messages.removeAll()
      self.subscription.messages.appendContentsOf(messages)
    }
    self.reloadMessages()
  }
  
  func reloadMessages() {
    messages = subscription.messages.sorted("createdAt").map { message -> JSQMessage in
      return JSQMessage(senderId: message.category?.rawValue, senderDisplayName: "", date: message.createdAt, text: message.content)
    }
    collectionView?.reloadData()
  }
  
  // MARK: JSQMessagesViewController method overrides
  
  override func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
    let message = Message()
    message.content = text
    message.category = .User
    
    subscriptionsProvider.request(.CreateMessage(subscriptionId: subscription.id, message: message)) { (result) in
      switch result  {
      case .Success(let response):
        do {
          try response.filterSuccessfulStatusCodes()
          let message = try response.mapObject(Message.self)
          let realm = try! Realm()
          try! realm.write {
            self.subscription.messages.append(message)
          }
          self.reloadMessages()
          self.scrollToBottomAnimated(true)
        } catch let error {
          print(error)
          self.presentAlertWithMessage("Cannot send your message")
        }
      case .Failure(let error):
        print(error)
        self.presentAlertWithMessage("Cannot send your message. Check your internet conneciton")
      }
    
      self.reloadMessages()
      self.finishSendingMessageAnimated(true)
    }
  }
  
  //MARK: JSQMessages CollectionView DataSource
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
    
    let message = messages[indexPath.item]
    
    if message.senderId == self.senderId {
      cell.textView!.textColor = UIColor.whiteColor()
    } else {
      cell.textView!.textColor = UIColor.blackColor()
    }
    
    return cell
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource? {
    return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData {
    return messages[indexPath.item]
  }
  
}
