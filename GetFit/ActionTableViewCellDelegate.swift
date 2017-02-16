//
//  ActionTableViewCellDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

protocol ActionTableViewCellDelegate: class {
  func didSelectActionCell(_ cell: ActionTableViewCell)
}

extension ActionTableViewCellDelegate {
  func didSelectActionCell(_ cell: ActionTableViewCell) { }
}
