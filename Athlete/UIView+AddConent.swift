//
//  UIView+AddConent.swift
//  GetHelp
//
//  Created by Dan Shevlyuk on 06/01/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

extension UIView {
  
  static func addContent(content: UIView, toView contentView: UIView) {
    
    content.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(content)
    
    let topConstraint = NSLayoutConstraint(item: content,
      attribute: NSLayoutAttribute.Top,
      relatedBy: NSLayoutRelation.Equal,
      toItem: contentView,
      attribute: NSLayoutAttribute.Top,
      multiplier: 1,
      constant: 0
    )
    
    let bottomContraint = NSLayoutConstraint(item: content,
      attribute: .Bottom,
      relatedBy: .Equal,
      toItem: contentView,
      attribute: .Bottom,
      multiplier: 1,
      constant: 0
    )
    
    let trallingConstaint = NSLayoutConstraint(item: content,
      attribute: .Trailing,
      relatedBy: .Equal,
      toItem: contentView,
      attribute: .Trailing,
      multiplier: 1,
      constant: 0
    )
    
    let leadingConstraint = NSLayoutConstraint(item: content,
      attribute: .Leading,
      relatedBy: .Equal,
      toItem: contentView,
      attribute: .Leading,
      multiplier: 1,
      constant: 0
    )
    
    contentView.addConstraints([topConstraint, bottomContraint, leadingConstraint, trallingConstaint])
  }
}