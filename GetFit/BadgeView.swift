import UIKit
import PureLayout

private var darkColor = UIColor.graySecondaryColor()
private var lightGrayColor = UIColor.white
private var lightBlueColor = UIColor.blueAccentColor()

@objc class BadgeView: UIView {
  let animationDuration = 0.2

  var label: UILabel

  struct Style {
    let color: ColorScheme
    let height: HeightType

    init(color: ColorScheme, height: HeightType = .low) {
      self.color = color
      self.height = height
    }
  }

  var isHighlighted: Bool = false {
    didSet {
      UIView.animate(withDuration: animationDuration, animations: {
        self.label.textColor = self.isHighlighted ? UIColor.white : self.style.color.primaryColor
        self.backgroundColor = self.isHighlighted ? self.style.color.primaryColor : UIColor.white
      }, completion: nil)
    }
  }

  enum ColorScheme {
    case dark
    case lightGray
    case lightBlue

    var primaryColor: UIColor {
      switch self {
      case .lightGray:
        return lightGrayColor
      case .dark:
        return darkColor
      case .lightBlue:
        return lightBlueColor
      }

    }
  }

  enum HeightType {
    case low
    case tall
  }

  var style: Style = Style(color: .lightGray, height: .low) {
    didSet {
      updateStyle(style)
    }
  }

  var fontSize: CGFloat {
    get {
      return label.font.pointSize
    }
    set(newFontSize) {
      label.font = label.font.withSize(newFontSize)
    }
  }

  var text: String? {
    get {
      return label.text
    }
    set(newText) {
      label.text = newText?.uppercased()
      updateConstraints()
    }
  }

  override init(frame: CGRect) {
    label = UILabel()
    super.init(frame: frame)
    baseInit()
  }

  required init?(coder aDecoder: NSCoder) {
    label = UILabel()
    super.init(coder: aDecoder)
    baseInit()
  }

  fileprivate func baseInit() {
    configureLabel()

    layer.borderWidth = 1
    layer.cornerRadius = 2

    updateStyle(style)
  }

  fileprivate func configureLabel() {
    label.font = UIFont.boldSystemFont(ofSize: 13)

    addSubview(label)
    label.autoCenterInSuperview()
  }

  fileprivate func updateStyle(_ style: Style) {
    switch style.color {
    case .lightGray:
      layer.borderColor = darkColor.cgColor
      backgroundColor = UIColor.white
      label.textColor = darkColor
    case .dark:
      layer.borderColor = darkColor.cgColor
      backgroundColor = darkColor
      label.textColor = lightGrayColor
    case .lightBlue:
      layer.borderColor = lightBlueColor.cgColor
      backgroundColor = UIColor.white
      label.textColor = lightBlueColor
    }
  }

  override func updateConstraints() {
    super.updateConstraints()
    label.sizeToFit()
    setNeedsLayout()
    layoutIfNeeded()

    switch style.height {
    case .low:
      autoSetDimension(.height, toSize: label.frame.height + 10)
    case .tall:
      autoSetDimension(.height, toSize: label.frame.height + 16)
    }
    autoSetDimension(.width, toSize: label.frame.width + 26)
  }
}
