import Foundation

enum Notification: String {
  case ReloadMessages
}

extension NotificationCenter {
  func post(_ notification: Notification) {
    self.post(name: Foundation.Notification.Name(rawValue: notification.rawValue), object: nil, userInfo: nil)
  }
  
  func addObserver(_ observer: AnyObject, selector: Selector, notification: Notification) {
    self.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: notification.rawValue), object: nil)
  }
}
