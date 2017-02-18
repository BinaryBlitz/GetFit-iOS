import Foundation

protocol UserPresentable {
  var name: String { get }
  var info: String { get }
  var avatarURL: URL? { get }
  var coverImageURL: URL? { get }
}
