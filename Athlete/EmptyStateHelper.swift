import Foundation
import PureLayout

class EmptyStateHelper {
  
  enum Screen {
    case News
    case Trainers
    case Store
  }
  
  static var avatarPlaceholderImage: UIImage {
    return UIImage(named: "AvatarPlaceholder")!
  }
  
  static func backgroundViewFor(screenType: Screen) -> UIView {
    let view = UIView()
    let titleLable = UILabel()
    titleLable.textAlignment = .Center
    titleLable.textColor = UIColor.graySecondaryColor().colorWithAlphaComponent(0.8)
    titleLable.font = UIFont.systemFontOfSize(16)
    titleLable.text = titleFor(screenType)
    
    let imageView = UIImageView()
    imageView.contentMode = .ScaleAspectFit
    imageView.autoSetDimensionsToSize(CGSize(width: 70, height: 70))
    imageView.image = UIImage(named: "FolderIcon")
    
    let stackView = UIStackView(arrangedSubviews: [imageView, titleLable])
    stackView.axis = .Vertical
    stackView.alignment = .Center
    stackView.distribution = .EqualSpacing
    stackView.spacing = 6
    
    view.addSubview(stackView)
    stackView.autoCenterInSuperview()
    
    return view
  }
  
  private static func titleFor(screenType: Screen) -> String {
    switch screenType {
    case .News:
      return "No news to show"
    case .Trainers:
      return "No trainers to show"
    case .Store:
      return "No programs to show"
    }
  }
}
