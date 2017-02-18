import UIKit
import PureLayout

class ButtonsStripView: UIView {
  
  var labels = [String]() {
    didSet {
      reloadButtons()
    }
  }
  
  let stackView = UIStackView(frame: CGRect.zero)
  var selectedIndex = 0 {
    didSet {
      reloadButtons()
    }
  }
  
  weak var delegate: ButtonStripViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(labels: [String]) {
    super.init(frame: CGRect.zero)
    self.labels = labels
    setup()
  }
  
  fileprivate func setup() {
    backgroundColor = UIColor.lightGrayBackgroundColor()
    stackView.alignment = .fill
    stackView.distribution = .fillProportionally
    stackView.axis = .horizontal
    stackView.spacing = 7
    addSubview(stackView)
    
    reloadButtons()
    stackView.autoConstrainAttribute(.height, to: .height, of: self, withMultiplier: 0.6)
    stackView.autoSetDimension(.width, toSize: calculateStackWidth())
    stackView.autoCenterInSuperview()
  }
  
  fileprivate func reloadButtons() {
    stackView.removeAllSubviews()
    let items = labels.map { (label) -> StripButtonItem in
      let button = StripButtonItem(title: label)
      button.titleColor = UIColor.graySecondaryColor()
      button.selectedTitleColor = UIColor.blackTextColor()
      button.backgroundColor = UIColor.lightGrayBackgroundColor()
      
      return button
    }
    items[selectedIndex].itemState = .selected
    items.forEach { (item) in
      item.addTarget(self, action: #selector(self.itemAction(_:)), for: .touchUpInside)
      stackView.addArrangedSubview(item)
    }
  }
  
  fileprivate func calculateStackWidth() -> CGFloat {
    var width: CGFloat = 0.0
    let items = stackView.arrangedSubviews
    items.forEach { item in
      item.sizeToFit()
      width += item.frame.width
    }
    
    width += CGFloat(items.count) * stackView.spacing
    
    return width
  }
  
  func indexOfItemInStack(_ item: UIView) -> Int? {
    let items = stackView.arrangedSubviews
    return items.index(of: item)
  }
  
  func itemAtIndex(_ index: Int) -> StripButtonItem? {
    let items = stackView.arrangedSubviews
    guard index < items.count && index >= 0 else {
      return nil
    }
    
    return items[index] as? StripButtonItem
  }
  
  @objc fileprivate func itemAction(_ sender: UIButton) {
    if let item = sender as? StripButtonItem {
      if item.itemState == .normal {
        let selectedItem = itemAtIndex(selectedIndex)
        selectedItem?.itemState = .normal
        item.itemState = .selected
        selectedIndex = indexOfItemInStack(item) ?? 0
        delegate?.stripView(self, didSelectItemAtIndex: selectedIndex)
      }
    }
  }
}
