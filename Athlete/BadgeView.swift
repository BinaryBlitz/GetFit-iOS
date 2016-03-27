//
//  BadgeView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 21/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PureLayout

@objc class BadgeView: UIView {
  
  private var label: UILabel
  private var darkColor = UIColor.graySecondaryColor()
  private var lightGrayColor = UIColor.whiteColor()
  private var lightBlueColor = UIColor.blueAccentColor()
  
  enum Style {
    case Dark
    case LightGray
    case LightBlue
  }
  
  var style: Style = .LightGray {
    didSet {
      updateStyle(style)
    }
  }
  
  var fontSize: CGFloat {
    get {
      return label.font.pointSize
    }
    set(newFontSize) {
      label.font = label.font.fontWithSize(newFontSize)
    }
  }
  
  var text: String? {
    get {
      return label.text
    }
    set(newText) {
      label.text = newText?.uppercaseString
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
  
  private func baseInit() {
    configureLabel()
    
    layer.borderWidth = 1
    layer.cornerRadius = 2
    
    updateStyle(style)
  }
  
  private func configureLabel() {
    label.font = UIFont.boldSystemFontOfSize(13)
    
    addSubview(label)
    label.autoCenterInSuperview()
  }
  
  private func updateStyle(style: Style) {
    switch style {
    case .LightGray:
      layer.borderColor = darkColor.CGColor
      backgroundColor = UIColor.whiteColor()
      label.textColor = darkColor
    case .Dark:
      layer.borderColor = darkColor.CGColor
      backgroundColor = darkColor
      label.textColor = lightGrayColor
    case .LightBlue:
      layer.borderColor = lightBlueColor.CGColor
      backgroundColor = UIColor.whiteColor()
      label.textColor = lightBlueColor
    }
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    label.sizeToFit()
    print(label.frame)
    autoSetDimension(.Width, toSize: label.frame.width + 26)
    autoSetDimension(.Height, toSize: label.frame.height + 10)
  }
}