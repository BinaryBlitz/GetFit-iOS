//
//  ActionTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import PureLayout
import InnerShadowView

class ActionTableViewCell: UITableViewCell {

  fileprivate let button = UIButton(frame: CGRect.zero)
  weak var delegate: ActionTableViewCellDelegate?
  
  var title: String? = nil {
    didSet {
      button.setTitle(title, for: UIControlState())
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none
    contentView.addSubview(button)
    button.autoPinEdgesToSuperviewEdges()
    button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    button.setTitleShadowColor(UIColor.lightGrayBackgroundColor().withAlphaComponent(0.3), for: UIControlState())
    button.setTitleShadowColor(UIColor.lightGrayBackgroundColor(), for: UIControlState.highlighted)
    button.setTitleColor(UIColor.lightGrayBackgroundColor().withAlphaComponent(0.4), for: UIControlState.highlighted)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    
    contentView.backgroundColor = UIColor.blueAccentColor()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc fileprivate func buttonAction(_ sender: UIButton) {
    delegate?.didSelectActionCell(self)
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    contentView.addInsetShadows(withRadius: 0.7, at: ShadowDirections.SHADOW_TOP)
    contentView.bringSubview(toFront: button)
  }
}
