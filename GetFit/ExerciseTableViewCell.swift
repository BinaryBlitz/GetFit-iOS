import UIKit
import SwipeCellKit
import Reusable

class ExerciseTableViewCell: SwipeTableViewCell, NibReusable {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var badgesStack: UIStackView!
  
  @IBOutlet weak var completeMarkImageView: UIImageView!
  
  var actionsDelegate: ExerciseCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()

    updateStatus(status)
  }
  
  //MARK: - Actions
  @IBAction func weightButtonAction(_ sender: AnyObject) {
    actionsDelegate?.didTapOnWeightButton?(self)
  }
  
  @IBAction func repetitionsButtonAction(_ sender: AnyObject) {
    actionsDelegate?.didTapOnRepetitionsButton?(self)
  }
  
  //MARK: - Status
  enum Status {
    case uncomplete
    case complete
  }
  
  var status: Status = .uncomplete {
    didSet {
      updateStatus(status)
    }
  }
  
  fileprivate func updateStatus(_ status: Status) {
    switch status {
    case .uncomplete:
      badgesStack.arrangedSubviews.forEach { view in
        view.layer.borderColor = UIColor.blueAccentColor().cgColor
        view.tintColor = UIColor.blueAccentColor()
        if let badge = view as? BadgeView {
          badge.label.font = UIFont.boldSystemFont(ofSize: 12)
        }
      }
      
      titleLabel.textColor = UIColor.blackTextColor()
      //defaultColor = UIColor.greenAccentColor()
      completeMarkImageView.isHidden = true
    case .complete:
      badgesStack.arrangedSubviews.forEach { view in
        view.layer.borderColor = UIColor.graySecondaryColor().cgColor
        view.tintColor = UIColor.graySecondaryColor()
        if let badge = view as? BadgeView {
          badge.label.font = UIFont.boldSystemFont(ofSize: 13)
        }
      }
      
      titleLabel.textColor = UIColor.graySecondaryColor()
      //defaultColor = UIColor.primaryYellowColor()
      completeMarkImageView.isHidden = false
    }
  }
  
  //MARK: - Configuration
  func configureWith(_ viewModel: ExerciseSessionPresentable) {
    status = viewModel.completed ? .complete : .uncomplete
    titleLabel.text = viewModel.exerciseName
    
    badgesStack.arrangedSubviews.forEach { view in badgesStack.removeArrangedSubview(view); view.removeFromSuperview() }
    
    if let reps = viewModel.repetitions {
      badgesStack.addArrangedSubview(createBadgeWith(title: reps))
    }
    
    if let weight = viewModel.weight {
      badgesStack.addArrangedSubview(createBadgeWith(title: weight))
    }
    
    if let distance = viewModel.distance {
      badgesStack.addArrangedSubview(createBadgeWith(title: distance))
    }
    
    if let sets = viewModel.sets {
      badgesStack.addArrangedSubview(createBadgeWith(title: sets))
    }
  }
  
  fileprivate func createBadgeWith(title: String) -> BadgeView {
    let badge = BadgeView()
    badge.style = BadgeView.Style(color: .lightBlue, height: .low)
    badge.text = title
    
    return badge
  }
}
