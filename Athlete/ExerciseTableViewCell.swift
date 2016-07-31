//
//  ExerciseTableViewCell.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 28/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell
import Reusable

class ExerciseTableViewCell: MCSwipeTableViewCell, NibReusable {

  @IBOutlet weak var completeMarkImageView: UIImageView!
  @IBOutlet weak var repetitionsButton: UIButton!
//  @IBOutlet weak var weightButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var badgesStack: UIStackView!
  var actionsDelegate: ExerciseCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    [repetitionsButton].forEach { button in
      button.layer.cornerRadius = 3
      button.layer.borderWidth = 1
      button.backgroundColor = nil
    }
    
    updateStatus(status)
  }
  
  //MARK: - Actions
  
  @IBAction func weightButtonAction(sender: AnyObject) {
    actionsDelegate?.didTapOnWeightButton?(self)
  }
  
  @IBAction func repetitionsButtonAction(sender: AnyObject) {
    actionsDelegate?.didTapOnRepetitionsButton?(self)
  }
  
  //MARK: - Status
  
  enum Status {
    case Uncomplete
    case Complete
  }
  
  var status: Status = .Uncomplete {
    didSet {
      updateStatus(status)
    }
  }
  
  private func updateStatus(status: Status) {
    switch status {
    case .Uncomplete:
      [repetitionsButton].forEach { button in
        button.layer.borderColor = UIColor.blueAccentColor().CGColor
        button.tintColor = UIColor.blueAccentColor()
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
      }
      
      titleLabel.textColor = UIColor.blackTextColor()
      defaultColor = UIColor.greenAccentColor()
      completeMarkImageView.hidden = true
    case .Complete:
      [repetitionsButton].forEach { button in
        button.layer.borderColor = UIColor.graySecondaryColor().CGColor
        button.tintColor = UIColor.graySecondaryColor()
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
      }
      
      titleLabel.textColor = UIColor.graySecondaryColor()
      defaultColor = UIColor.primaryYellowColor()
      completeMarkImageView.hidden = false
    }
  }
  
//  var exerciseName: String { get }
//  var repetitions: String? { get }
//  var weight: String? { get }
//  var distance: String? { get }
//  var sets: String? { get }
//  var completed: Bool { get }
  func configureWith(viewModel: ExerciseSessionPresentable) {
    status = viewModel.completed ? .Complete : .Uncomplete
    titleLabel.text = viewModel.exerciseName
    
    repetitionsButton.setTitle(viewModel.repetitions ?? "0", forState: .Normal)
    
//    if let weight = viewModel.weight {
//      weightButton.setTitle(weight, forState: .Normal)
//    } else {
//      badgesStack.removeArrangedSubview(weightButton)
//    }
  }
}
