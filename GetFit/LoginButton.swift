import UIKit

@objc class LoginButton: UIButton {
  
  var text: String? {
    didSet {
      setTitle(text, for: UIControlState())
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    basicInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    basicInit()
  }
  
  func basicInit() {
    layer.borderColor = UIColor.primaryYellowColor().cgColor
    layer.borderWidth = 2.4
    layer.cornerRadius = 3
    titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    setTitleColor(UIColor.primaryYellowColor(), for: UIControlState())
    backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.6)
  }
}
