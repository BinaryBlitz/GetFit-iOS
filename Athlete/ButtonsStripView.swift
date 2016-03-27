//
//  ButtonsStripView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 26/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class StripButtonItem: UIButton {
  
  var titleColor = UIColor.graySecondaryColor() {
    didSet {
      setTitleColor(titleColor, forState: UIControlState.Normal)
    }
  }
}

class ButtonsStripView: UIView {

  var labels = [String]()
  let stackView: UIStackView = {
    let sv = UIStackView(frame: CGRect.zero)
    sv.alignment = .Fill
    sv.distribution = .FillProportionally
    sv.axis = .Horizontal
    
    return sv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(labels: [String]) {
    super.init(frame: CGRect.zero)
    setup()
  }
  
  private func setup() {
    
  }
}
