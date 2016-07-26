import Foundation
import SwiftDate

protocol SubscriptionPresentable {
  var title: String { get }
  var lastMessage: String? { get }
  var avatarURL: NSURL { get }
  var updatedAt: String { get }
}

struct SubscriptionViewModel {
  let subscription: Subscription
  
  private lazy var dateFormat = DateFormat.Custom("dd.MM")
}

extension SubscriptionViewModel: SubscriptionPresentable {
  var title: String {
    return subscription.trainer.name
  }
  
  var lastMessage: String? {
    return subscription.lastMessage?.content
  }
  
  var avatarURL: NSURL { get }
  
  var updatedAt: String {
    if let lastMessage = subscription.lastMessage {
      
    } else {
      return subscription.createdAt.toString(dateFormat)!
    }
  }
  
}
