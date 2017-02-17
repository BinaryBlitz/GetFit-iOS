import Foundation
import PureLayout

class EmptyStateHelper {
  
  enum Screen {
    case news
    case trainers
    case store
  }
  
  static var avatarPlaceholderImage: UIImage {
    return UIImage(named: "AvatarPlaceholder")!
  }
  
  static func generateBannerImageFor(_ object: NamedObject) -> UIImage? {
    switch object.objectName.characters.count % 3 {
    case 0:
      return UIImage(color: .primaryYellowColor())
    case 1:
      return UIImage(color: .blueAccentColor())
    default:
      return UIImage(color: .greenAccentColor()) // for case 2 and default
    }
  }
  
  static func backgroundViewFor(_ screenType: Screen) -> UIView {
    let view = UIView()
    let titleLable = UILabel()
    titleLable.textAlignment = .center
    titleLable.textColor = UIColor.graySecondaryColor().withAlphaComponent(0.8)
    titleLable.font = UIFont.systemFont(ofSize: 16)
    titleLable.text = titleFor(screenType)
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.autoSetDimensions(to: CGSize(width: 70, height: 70))
    imageView.image = UIImage(named: "FolderIcon")
    
    let stackView = UIStackView(arrangedSubviews: [imageView, titleLable])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.spacing = 6
    
    view.addSubview(stackView)
    stackView.autoCenterInSuperview()
    
    return view
  }
  
  fileprivate static func titleFor(_ screenType: Screen) -> String {
    switch screenType {
    case .news:
      return "No news to show"
    case .trainers:
      return "No trainers to show"
    case .store:
      return "No programs to show"
    }
  }
}

public extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image!.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
