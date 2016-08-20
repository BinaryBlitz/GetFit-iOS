import UIKit
import Reusable

class StatisticsTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var caloriesView: UIView!
  @IBOutlet weak var distanceView: UIView!
  @IBOutlet weak var lengthView: UIView!
  @IBOutlet weak var trainingsView: UIView!
  
  @IBOutlet weak var totalTrainingsLabel: UILabel!
  @IBOutlet weak var trainingsTitleLabel: UILabel!
  
  @IBOutlet weak var totalDurationLabel: UILabel!
  @IBOutlet weak var durationTitleLabel: UILabel!
  
  @IBOutlet weak var totalDistanceLabel: UILabel!
  @IBOutlet weak var distanceTitleLabel: UILabel!
  
  @IBOutlet weak var totalWeightLabel: UILabel!
  @IBOutlet weak var weightTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    [caloriesView, distanceView, lengthView, trainingsView].forEach { (view) in
      view.layer.borderWidth = 3
    }
    
    caloriesView.layer.borderColor = UIColor.redColor().CGColor
    trainingsView.layer.borderColor = UIColor.blueAccentColor().CGColor
    lengthView.layer.borderColor = UIColor.primaryYellowColor().CGColor
    distanceView.layer.borderColor = UIColor.greenAccentColor().CGColor
    
    [totalDistanceLabel, totalDurationLabel, totalWeightLabel, totalTrainingsLabel].forEach { label in
      label.text = "0"
    }
    
    trainingsTitleLabel.text = "Workouts"
    durationTitleLabel.text = "Duration"
    distanceTitleLabel.text = "Distance"
    weightTitleLabel.text = "Weight"
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    [caloriesView, distanceView, lengthView, trainingsView].forEach { (view) in
      view.layer.masksToBounds = true
      view.layer.cornerRadius = view.bounds.width / 2
    }
  }
  
  func configureWith(viewModel: StatisticsPresentable) {
    totalDistanceLabel.text = viewModel.totalDistance
    totalTrainingsLabel.text = viewModel.totalWorkouts
    totalDurationLabel.text = viewModel.totalDuration
    totalWeightLabel.text = viewModel.totalWeight
  }
}
