import Foundation

enum Notification: String {
  case ReloadMessages
}

extension NSNotificationCenter {
  func post(notification: Notification) {
    self.postNotificationName(notification.rawValue, object: nil, userInfo: nil)
  }
  
  func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
    self.addObserver(observer, selector: selector, name: notification.rawValue, object: nil)
  }
}
