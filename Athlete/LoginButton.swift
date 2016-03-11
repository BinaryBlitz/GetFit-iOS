//
//  LoginButton.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 10/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

class LoginButton: UIButton {
  
  private var overlay: UIView?
  
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
    layer.borderWidth = 3
    layer.cornerRadius = 3
    titleLabel?.font = UIFont.boldSystemFontOfSize(18)
    setTitleColor(UIColor.primaryYellowColor(), forState: UIControlState.Normal)
    
    let overlay = UIView(frame: frame)
    overlay.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.6)
    UIView.addContent(overlay, toView: self)
    sendSubviewToBack(overlay)
  }
}