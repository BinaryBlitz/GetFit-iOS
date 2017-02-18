import UIKit
import PureLayout

struct ExerciseParameter {
  let name: String
  let value: Int
}

class ExerciseParamsView: UIStackView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var separatorViewHeightConstraint: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()

    separatorViewHeightConstraint.constant = 1 / UIScreen.main.scale
    separatorView.backgroundColor = UIColor.graySecondaryColor()
    titleLabel.textColor = UIColor.graySecondaryColor()
    valueLabel.textColor = UIColor.blackTextColor()
  }

  func configureWithExerciseParameter(_ parameter: ExerciseParameter) {
    titleLabel.text = parameter.name.uppercased()
    updateValue(parameter.value)
  }

  func updateValue(_ value: Int) {
    valueLabel.text = String(value)
  }
}
