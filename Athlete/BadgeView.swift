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
  
  struct Style {
    let color: ColorScheme
    let height: HeightType
    
    init(color: ColorScheme, height: HeightType = .Low) {
      self.color = color
      self.height = height
    }
  }
  
  enum ColorScheme {
    case Dark
    case LightGray
    case LightBlue
  }
  
  enum HeightType {
    case Low
    case Tall
  }
  
  var style: Style = Style(color: .LightGray, height: .Low) {
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
    switch style.color {
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
    switch style.height {
    case .Low:
      autoSetDimension(.Height, toSize: label.frame.height + 10)
    case .Tall:
      autoSetDimension(.Height, toSize: label.frame.height + 16)
    }
    autoSetDimension(.Width, toSize: label.frame.width + 26)
  }
}