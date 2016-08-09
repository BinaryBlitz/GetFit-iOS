import UIKit
import MCSwipeTableViewCell
import Reusable

class TrainingTableViewCell: MCSwipeTableViewCell, NibReusable {
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var badgesStackView: UIStackView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel.textColor = UIColor.blueAccentColor()
    defaultColor = UIColor.graySecondaryColor()
    
    let dateBadge = BadgeView()
    dateBadge.style = BadgeView.Style(color: .Dark, height: .Low)
    badgesStackView.addArrangedSubview(dateBadge)
    
    let durationBadge = BadgeView()
    durationBadge.style = BadgeView.Style(color: .LightGray, height: .Low)
    badgesStackView.addArrangedSubview(durationBadge)
  }
  
  func configureWith(viewModel: TrainingPresentable) {
    titleLabel.text = viewModel.trainingTitle
    
    updateInfoLabelWithTitle(viewModel.trainingInfo, andSubtitle: "\(viewModel.trainingExercisesCount) exercises")
    
    if let dateBadge = badgesStackView.arrangedSubviews.first as? BadgeView {
      dateBadge.text = viewModel.trainingDateString
      dateBadge.updateConstraints()
    }
    
    if let durationBadge = badgesStackView.arrangedSubviews.last as? BadgeView {
      durationBadge.text = viewModel.trainingDurationString
      durationBadge.updateConstraints()
    }
  }
  
  private func updateInfoLabelWithTitle(title: String, andSubtitle subtitle: String) {
    let infoFontSize: CGFloat = 15
    let boldTextAttrebutes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(infoFontSize)]
    let infoString = NSMutableAttributedString(string: title, attributes:boldTextAttrebutes)
    let plainTextAttrebutes = [NSFontAttributeName : UIFont.systemFontOfSize(infoFontSize)]
    infoString.appendAttributedString(NSMutableAttributedString(string: ", \(subtitle)", attributes: plainTextAttrebutes))
    infoLabel.attributedText = infoString
  }
}
