import Foundation
import SwiftDate

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
  
  var updatedAt: String {
    if let lastMessage = subscription.lastMessage {
      
    } else {
      return subscription.createdAt.toString(dateFormat)!
    }
  }
  
}
