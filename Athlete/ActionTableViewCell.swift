//
//  ActionTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PureLayout

class ActionTableViewCell: UITableViewCell {

  private let button = UIButton(frame: CGRect.zero)
  weak var delegate: ActionTableViewCellDelegate?
  
  var title: String? = nil {
    didSet {
      button.setTitle(title, forState: .Normal)
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .None
    addSubview(button)
    button.autoPinEdgesToSuperviewEdges()
    button.backgroundColor = UIColor.blueAccentColor()
    button.addTarget(self, action: #selector(buttonAction(_:)), forControlEvents: .TouchDragInside)
    button.setTitleShadowColor(UIColor.lightGrayBackgroundColor().colorWithAlphaComponent(0.3), forState: UIControlState.Normal)
    button.setTitleShadowColor(UIColor.lightGrayBackgroundColor(), forState: UIControlState.Highlighted)
    button.setTitleColor(UIColor.lightGrayBackgroundColor().colorWithAlphaComponent(0.4), forState: UIControlState.Highlighted)
    button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func buttonAction(sender: UIButton) {
    delegate?.didSelectActionCell(self)
  }
}
