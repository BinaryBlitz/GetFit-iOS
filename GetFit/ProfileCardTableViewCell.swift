import UIKit
import Kingfisher
import Reusable

typealias ProfileCardPresentable = UserPresentable & StatisticsPresentable

class ProfileCardTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var avatarImageView: CircleImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var settingsBadge: BadgeView!
  @IBOutlet weak var workoutsLabel: UILabel!
  @IBOutlet weak var weightLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!

  let settingsButton = UIButton()

  override func awakeFromNib() {
    super.awakeFromNib()

    avatarImageView.layer.borderColor = UIColor.white.cgColor
    avatarImageView.layer.borderWidth = 5
    avatarImageView.image = EmptyStateHelper.avatarPlaceholderImage
    avatarImageView.backgroundColor = UIColor.primaryYellowColor()
    avatarImageView.contentMode = .scaleAspectFill

    settingsBadge.style = BadgeView.Style(color: .lightBlue, height: .tall)
    settingsBadge.text = "Settings"


    settingsBadge.addSubview(settingsButton)
    settingsButton.autoPinEdgesToSuperviewEdges()

    settingsButton.addTarget(self, action: #selector(settingsButtonDidEndTouch(_:)), for: .touchUpInside)
    settingsButton.addTarget(self, action: #selector(settingsButtonDidTouch(_:)), for: .touchDown)
    settingsButton.addTarget(self, action: #selector(settingsButtonDidEndTouch(_:)), for: .touchDragExit)

  }

  func settingsButtonDidTouch(_ button: UIButton) {
    settingsBadge.isHighlighted = true
  }

  func settingsButtonDidEndTouch(_ button: UIButton) {
    settingsBadge.isHighlighted = false
  }

  func configureWith(_ viewModel: ProfileCardPresentable) {
    nameLabel.text = viewModel.name
    distanceLabel.text = viewModel.totalDistance
    workoutsLabel.text = viewModel.totalWorkouts
    durationLabel.text = viewModel.totalDuration
    weightLabel.text = viewModel.totalWeight

    avatarImageView.kf.cancelDownloadTask()
    if let avatarURL = viewModel.avatarURL {
      avatarImageView.kf.setImage(with: avatarURL)
    }
  }
}
