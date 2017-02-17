//
//  ExerciseCellDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

@objc protocol ExerciseCellDelegate {
  @objc optional func didTapOnWeightButton(_ cell: UITableViewCell)
  @objc optional func didTapOnRepetitionsButton(_ cell: UITableViewCell)
}
