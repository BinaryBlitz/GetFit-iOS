//
//  LoginButton.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 10/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

@objc class LoginButton: UIButton {
  
  var text: String? {
    didSet {
      setTitle(text, forState: UIControlState.Normal)
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
    layer.borderColor = UIColor.primaryYellowColor().CGColor
    layer.borderWidth = 2.4
    layer.cornerRadius = 3
    titleLabel?.font = UIFont.boldSystemFontOfSize(18)
    setTitleColor(UIColor.primaryYellowColor(), forState: UIControlState.Normal)
    backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.6)
  }
}