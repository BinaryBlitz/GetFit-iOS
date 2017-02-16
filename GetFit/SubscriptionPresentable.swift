import Foundation

protocol SubscriptionPresentable {
  var name: String { get }
  var lastMessage: String? { get }
  var createdAt: String { get }
  var avatarImageURL: URL? { get }
}
