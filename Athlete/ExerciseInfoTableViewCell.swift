import UIKit

class ExerciseInfoTableViewCell: UITableViewCell {

  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var showTipsButton: UIButton!
  @IBOutlet weak var parametersStackView: UIStackView!

  override func awakeFromNib() {
    super.awakeFromNib()

    showTipsButton.backgroundColor = UIColor.blueAccentColor()
  }

  func configureWith(session: ExerciseSession) {
    parametersStackView.removeAllSubviews()
    
    if let reps = session.reps.value {
      let repsView = loadExerciseParamsViewFor(ExerciseParameter(name: "reps", value: reps))
      parametersStackView.addArrangedSubview(repsView)
    }

    if let distance = session.distance.value {
      let distView = loadExerciseParamsViewFor(ExerciseParameter(name: "distance, km", value: distance))
      parametersStackView.addArrangedSubview(distView)
    }

    if let sets = session.sets.value {
      let setsView = loadExerciseParamsViewFor(ExerciseParameter(name: "sets", value: sets))
      parametersStackView.addArrangedSubview(setsView)
    }

    if let weight = session.weight.value {
      let weightView = loadExerciseParamsViewFor(ExerciseParameter(name: "weight, kg", value: weight))
      parametersStackView.addArrangedSubview(weightView)
    }
  }

  private func loadExerciseParamsViewFor(parameter: ExerciseParameter) -> ExerciseParamsView {
    let view = NSBundle.mainBundle().loadNibNamed(String(ExerciseParamsView), owner: self, options: nil).first as! ExerciseParamsView
    view.configureWithExerciseParameter(parameter)
    return view
  }
}
