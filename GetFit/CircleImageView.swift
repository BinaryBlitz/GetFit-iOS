//
//  CircleImageView.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 21/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
  
  fileprivate func baseInit() {
    layer.cornerRadius = frame.width / 2
    clipsToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    baseInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    baseInit()
  }
  
  override init(image: UIImage?) {
    super.init(image: image)
    baseInit()
  }
  
  override init(image: UIImage?, highlightedImage: UIImage?) {
    super.init(image: image, highlightedImage: highlightedImage)
    baseInit()
  }
}
