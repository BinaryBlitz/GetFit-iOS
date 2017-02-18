import Foundation

protocol ProgramPresentable {
  var title: String { get }
  var price: String { get }
  var info: NSAttributedString { get }
  var category: String { get }
  var workoutsCount: String { get }
  var description: String { get }
  var preview: String { get }
  var followers: String { get }
  var rating: String { get }
  var duration: String { get }
  var bannerURL: URL? { get }
}
