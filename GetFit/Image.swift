import UIKit

public enum Image: String {
  case Banner
  case Avatar

  var imageSize: CGSize {
    switch self {
    case .Avatar:
      return CGSize(width: 180, height: 180)
    case .Banner:
      return CGSize(width: 800, height: 320)
    }
  }
}
