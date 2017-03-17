//
//  RatingViewController.swift
//  GetFit
//
//  Created by Алексей on 18.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import Moya

class RatingViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var reviewContentField: UITextField!

  enum RatingType {
    case trainer(Trainer)
    case program(Program)
  }

  let programsProvider = APIProvider<GetFit.Programs>()
  let trainersProvider = APIProvider<GetFit.Trainers>()

  var ratingType: RatingType! {
    didSet {
      switch ratingType! {
      case .trainer(let trainer):
        titleLabel.text = trainer.name
        descriptionLabel.text = "Rate trainer"
      case .program(let program):
        titleLabel.text = program.name
        descriptionLabel.text = "Rate program"
      }
    }
  }
  
  // Constants
  let animationDuration = 0.2

  override func viewDidLoad() {
    reviewContentField.inputAccessoryView = UIView()
    hideKeyboardWhenTappedAround()
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
  }

  override func viewWillAppear(_ animated: Bool) {
    UIView.animate(withDuration: animationDuration) { [weak self] in
      self?.view.alpha = 0
      self?.view.alpha = 1
    }
  }

  @IBAction func continueButtonDidTap(_ sender: UIButton) {
    sender.isEnabled = false

    let responseCompletionBlock: Moya.Completion = { [weak self] result in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          UIView.animate(withDuration: self?.animationDuration ?? 0, animations: {
            self?.view.alpha = 0
          }, completion: { _ in
            self?.dismiss(animated: false, completion: nil)
          })
        } catch {
          self?.presentAlertWithMessage("error with code: \(response.statusCode)")
        }
      case .failure(let error):
        self?.presentAlertWithMessage("error with code: \(error.errorDescription ?? "")")
      }
    }

    switch ratingType! {
    case .trainer(let trainer):
      trainersProvider.request(.createRating(trainerId: trainer.id, value: Int(ratingView.rating), content: reviewContentField.text ?? ""), completion: responseCompletionBlock)
    case .program(let program):
      programsProvider.request(.createRating(programId: program.id, value: Int(ratingView.rating), content: reviewContentField.text ?? ""), completion: responseCompletionBlock)
    }
  }

}
