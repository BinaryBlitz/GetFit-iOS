//
//  CardView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 21/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

class CardView: UIView {
  
  private func baseInit() {
    layer.cornerRadius = 2
    layer.shadowColor = UIColor.lightGrayColor().CGColor
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