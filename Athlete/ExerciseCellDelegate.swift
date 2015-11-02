//
//  ExerciseCellDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@objc protocol ExerciseCellDelegate {
  optional func didTapOnWeightButton(cell: UITableViewCell)
  optional func didTapOnRepetitionsButton(cell: UITableViewCell)
}