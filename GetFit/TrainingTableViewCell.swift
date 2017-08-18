import UIKit
import Reusable
import SwipeCellKit

class TrainingTableViewCell: SwipeTableViewCell, NibReusable {

  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var badgesStackView: UIStackView!

  @IBOutlet weak var completedMarkImageView: UIImageView!

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
      titleLabel.textColor = UIColor.blackTextColor()
      infoLabel.textColor = UIColor.blackTextColor()
      completedMarkImageView.isHidden = true
    case .complete:
      titleLabel.textColor = UIColor.graySecondaryColor()
      infoLabel.textColor = UIColor.graySecondaryColor()
      completedMarkImageView.isHidden = false
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    titleLabel.textColor = UIColor.blueAccentColor()
    //defaultColor = UIColor.graySecondaryColor()

    let dateBadge = BadgeView()
    dateBadge.style = BadgeView.Style(color: .dark, height: .low)
    badgesStackView.addArrangedSubview(dateBadge)

    let durationBadge = BadgeView()
    durationBadge.style = BadgeView.Style(color: .lightGray, height: .low)
    badgesStackView.addArrangedSubview(durationBadge)
  }

  func configureWith(_ viewModel: TrainingPresentable) {
    status = viewModel.completed ? .complete : .uncomplete
    titleLabel.text = viewModel.trainingTitle

    updateInfoLabelWithTitle(viewModel.trainingInfo, andSubtitle: "\(viewModel.trainingExercisesCount)")

    if let dateBadge = badgesStackView.arrangedSubviews.first as? BadgeView {
      dateBadge.text = viewModel.trainingDateString
      dateBadge.updateConstraints()
    }
    

    if let durationBadge = badgesStackView.arrangedSubviews.last as? BadgeView {
      durationBadge.text = viewModel.trainingDurationString
      durationBadge.updateConstraints()
    }
  }

  fileprivate func updateInfoLabelWithTitle(_ title: String, andSubtitle subtitle: String) {
    let infoFontSize: CGFloat = 15
    let boldTextAttrebutes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: infoFontSize)]
    let infoString = NSMutableAttributedString(string: title, attributes: boldTextAttrebutes)
    let plainTextAttrebutes = [NSFontAttributeName: UIFont.systemFont(ofSize: infoFontSize)]
    infoString.append(NSMutableAttributedString(string: ", \(subtitle)", attributes: plainTextAttrebutes))
    infoLabel.attributedText = infoString
  }
}
