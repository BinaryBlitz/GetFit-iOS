//
//  CardView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 21/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

@objc class CardView: UIView {
  
  fileprivate func baseInit() {
    layer.cornerRadius = 2
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 1.3
    layer.shadowOffset = CGSize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    baseInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    baseInit()
  }
}
