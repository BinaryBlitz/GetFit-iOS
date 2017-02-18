import UIKit

internal class StripButtonItem: UIButton {

  enum ItemState {
    case selected
    case normal
  }

  var title: String = "" {
    didSet {
      setTitle(title, for: UIControlState())
    }
  }

  var titleColor: UIColor = UIColor.gray.withAlphaComponent(0.5) {
    didSet {
      if itemState == .normal {
        setTitleColor(titleColor, for: UIControlState())
      }
    }
  }

  var selectedTitleColor: UIColor = UIColor.gray {
    didSet  {
      if itemState == .selected {
        setTitleColor(selectedTitleColor, for: UIControlState())
      }
    }
  }

  var itemState: ItemState = .normal {
    didSet {
      switch itemState {
      case .selected:
        setTitleColor(selectedTitleColor, for: UIControlState())
      case .normal:
        setTitleColor(titleColor, for: UIControlState())
      }
    }
  }

  init(title: String) {
    super.init(frame: .zero)
    self.backgroundColor = UIColor.white
    self.title = title.uppercased()
    setTitle(title.uppercased(), for: UIControlState())
    titleColor = UIColor.gray.withAlphaComponent(0.5)
    selectedTitleColor = UIColor.gray
    //    setTitleColor(UIColor.blueColor().colorWithAlphaComponent(0.3), forState: .Highlighted)
    //    setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.3), forState: .Highlighted)
    titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
