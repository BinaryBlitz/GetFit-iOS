import UIKit
import MCSwipeTableViewCell
import Reusable

class ExerciseTableViewCell: MCSwipeTableViewCell, NibReusable {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var badgesStack: UIStackView!
  
  @IBOutlet weak var completeMarkImageView: UIImageView!
  
  var actionsDelegate: ExerciseCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
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
      badgesStack.arrangedSubviews.forEach { view in
        view.layer.borderColor = UIColor.blueAccentColor().CGColor
        view.tintColor = UIColor.blueAccentColor()
        if let badge = view as? BadgeView {
          badge.label.font = UIFont.boldSystemFontOfSize(12)
        }
      }
      
      titleLabel.textColor = UIColor.blackTextColor()
      defaultColor = UIColor.greenAccentColor()
      completeMarkImageView.hidden = true
    case .Complete:
      badgesStack.arrangedSubviews.forEach { view in
        view.layer.borderColor = UIColor.graySecondaryColor().CGColor
        view.tintColor = UIColor.graySecondaryColor()
        if let badge = view as? BadgeView {
          badge.label.font = UIFont.boldSystemFontOfSize(13)
        }
      }
      
      titleLabel.textColor = UIColor.graySecondaryColor()
      defaultColor = UIColor.primaryYellowColor()
      completeMarkImageView.hidden = false
    }
  }
  
  //MARK: - Configuration
  func configureWith(viewModel: ExerciseSessionPresentable) {
    status = viewModel.completed ? .Complete : .Uncomplete
    titleLabel.text = viewModel.exerciseName
    
    badgesStack.arrangedSubviews.forEach { view in badgesStack.removeArrangedSubview(view) }
    
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
  
  private func createBadgeWith(title title: String) -> BadgeView {
    let badge = BadgeView()
    badge.style = BadgeView.Style(color: .LightBlue, height: .Low)
    badge.text = title
    
    return badge
  }
}
