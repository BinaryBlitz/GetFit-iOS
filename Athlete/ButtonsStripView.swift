//
//  ButtonsStripView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

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
  
  private func setup() {
    backgroundColor = UIColor.lightGrayBackgroundColor()
    stackView.alignment = .Fill
    stackView.distribution = .FillProportionally
    stackView.axis = .Horizontal
    stackView.spacing = 8
    addSubview(stackView)
    
    reloadButtons()
    stackView.autoConstrainAttribute(.Height, toAttribute: .Height, ofView: self, withMultiplier: 0.6)
    stackView.autoSetDimension(.Width, toSize: calculateStackWidth())
    stackView.autoCenterInSuperview()
  }
  
  private func reloadButtons() {
    stackView.removeAllSubviews()
    let items = labels.map { (label) -> StripButtonItem in
      let button = StripButtonItem(title: label)
      button.titleColor = UIColor.graySecondaryColor()
      button.selectedTitleColor = UIColor.blackTextColor()
      button.backgroundColor = UIColor.lightGrayBackgroundColor()
      
      return button
    }
    items[selectedIndex].itemState = .Selected
    items.forEach { (item) in
      item.addTarget(self, action: #selector(self.itemAction(_:)), forControlEvents: .TouchUpInside)
      stackView.addArrangedSubview(item)
    }
  }
  
  private func calculateStackWidth() -> CGFloat {
    var width: CGFloat = 0.0
    let items = stackView.arrangedSubviews
    items.forEach { item in
      item.sizeToFit()
      width += item.frame.width
    }
    
    width += CGFloat(items.count) * stackView.spacing
    
    return width
  }
  
  func indexOfItemInStack(item: UIView) -> Int? {
    let items = stackView.arrangedSubviews
    return items.indexOf(item)
  }
  
  func itemAtIndex(index: Int) -> StripButtonItem? {
    let items = stackView.arrangedSubviews
    guard index < items.count && index >= 0 else {
      return nil
    }
    
    return items[index] as? StripButtonItem
  }
  
  @objc private func itemAction(sender: UIButton) {
    if let item = sender as? StripButtonItem {
      if item.itemState == .Normal {
        let selectedItem = itemAtIndex(selectedIndex)
        selectedItem?.itemState = .Normal
        item.itemState = .Selected
        selectedIndex = indexOfItemInStack(item) ?? 0
      }
      delegate?.stripView(self, didSelectItemAtIndex: selectedIndex)
    }
  }
}