import Foundation

protocol PostPresentable {
  var imageURL: URL? { get }
  var likesCount: String { get }
  var commentsCount: String { get }
  var liked: Bool { get }
  var program: Program? { get }
}
