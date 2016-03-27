//
//  StripButtonItem.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

internal class StripButtonItem: UIButton {
  
  enum ItemState {
    case Selected
    case Normal
  }
  
  var title: String = "" {
    didSet {
      setTitle(title, forState: .Normal)
    }
  }
  
  var titleColor: UIColor = UIColor.grayColor().colorWithAlphaComponent(0.5) {
    didSet {
      if itemState == .Normal {
        setTitleColor(titleColor, forState: .Normal)
      }
    }
  }
  
  var selectedTitleColor: UIColor = UIColor.grayColor() {
    didSet  {
      if itemState == .Selected {
        setTitleColor(selectedTitleColor, forState: .Normal)
      }
    }
  }
  
  var itemState: ItemState = .Normal {
    didSet {
      switch itemState {
      case .Selected:
        setTitleColor(selectedTitleColor, forState: .Normal)
      case .Normal:
        setTitleColor(titleColor, forState: .Normal)
      }
    }
  }
  
  init(title: String) {
    super.init(frame: .zero)
    self.backgroundColor = UIColor.whiteColor()
    self.title = title.uppercaseString
    setTitle(title.uppercaseString, forState: UIControlState.Normal)
    titleColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
    selectedTitleColor = UIColor.grayColor()
    //    setTitleColor(UIColor.blueColor().colorWithAlphaComponent(0.3), forState: .Highlighted)
    //    setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.3), forState: .Highlighted)
    titleLabel?.font = UIFont.boldSystemFontOfSize(17)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}