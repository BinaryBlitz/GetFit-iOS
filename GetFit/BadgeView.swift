import UIKit
import PureLayout

@objc class BadgeView: UIView {

  var label: UILabel
  fileprivate var darkColor = UIColor.graySecondaryColor()
  fileprivate var lightGrayColor = UIColor.white
  fileprivate var lightBlueColor = UIColor.blueAccentColor()

  struct Style {
    let color: ColorScheme
    let height: HeightType

    init(color: ColorScheme, height: HeightType = .low) {
      self.color = color
      self.height = height
    }
  }

  enum ColorScheme {
    case dark
    case lightGray
    case lightBlue
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
    switch style.height {
    case .low:
      autoSetDimension(.height, toSize: label.frame.height + 10)
    case .tall:
      autoSetDimension(.height, toSize: label.frame.height + 16)
    }
    autoSetDimension(.width, toSize: label.frame.width + 26)
  }
}
