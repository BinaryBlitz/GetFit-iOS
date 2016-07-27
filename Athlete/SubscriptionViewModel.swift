import Foundation
import SwiftDate

struct SubscriptionViewModel {
  let subscription: Subscription
}

extension SubscriptionViewModel: SubscriptionPresentable {
  var name: String {
    return subscription.trainer.name
  }

  var lastMessage: String? {
    guard let message = subscription.lastMessage else { return "No messages" }

    return message.content
  }

  var createdAt: String {
    let dateFormat: DateFormat = .Custom("dd.MM")

    if let message = subscription.lastMessage {
      return message.createdAt.toString(dateFormat)!
    } else {
      return subscription.createdAt.toString(dateFormat)!
    }
  }

  var avatarImageURL: NSURL? {
    guard let urlString = subscription.trainer.avatarURLString else { return nil }

    return NSURL(string: urlString)
  }
}
