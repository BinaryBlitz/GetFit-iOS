import UIKit
import Kingfisher
import PureLayout
import Reusable

protocol ProfessionalCellDelegate: class {
  func professionalCell(_ cell: ProfessionalTableViewCell, didChangeFollowingTo: Bool)
}

class ProfessionalTableViewCell: UITableViewCell, NibReusable {

  enum ProfessionalCellState {
    case normal
    case card
  }

  var state: ProfessionalCellState = .card {
    didSet {
      updateWithState(state)
    }
  }

  @IBOutlet weak var cardView: CardView!
  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var programsBadge: BadgeView!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var avatarImageView: CircleImageView!

  @IBOutlet weak var followButtonBackground: UIView!
  @IBOutlet weak var followButtonIcon: UIImageView!
  @IBOutlet weak var followButtonLabel: UILabel!

  var bannerMaskView: UIView?

  weak var delegate: ProfessionalCellDelegate?

  fileprivate var following: Bool = false {
    didSet {
      updateFollowingStatus(following)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.borderColor = UIColor.white.cgColor
    avatarImageView.layer.borderWidth = 3
    avatarImageView.backgroundColor = UIColor.yellow
    avatarImageView.image = EmptyStateHelper.avatarPlaceholderImage

    bannerImageView.contentMode = .scaleAspectFill
    bannerImageView.layer.masksToBounds = true
    bannerImageView.backgroundColor = UIColor.blueAccentColor()
    bannerImageView.image = nil

    setupFollowButton()
    updateFollowingStatus(following)

    let maskView = UIView()
    maskView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    bannerImageView.addSubview(maskView)
    maskView.autoPinEdgesToSuperviewEdges()
    bannerMaskView = maskView
  }

  func setupFollowButton() {
    let button = UIButton()
    followButtonBackground.addSubview(button)
    button.autoPinEdgesToSuperviewEdges()
    button.addTarget(self, action: #selector(followButtonAction(_:)), for: .touchUpInside)
    followButtonBackground.layer.borderWidth = 1
    followButtonBackground.layer.cornerRadius = 2
    followButtonLabel.text = "follow".uppercased()
  }

  func followButtonAction(_ sender: UIButton) {
    following = !following
    delegate?.professionalCell(self, didChangeFollowingTo: following)
  }

  func updateFollowingStatus(_ following: Bool) {
    if following {
      followButtonLabel.textColor = UIColor.white
      followButtonIcon.tintColor = UIColor.white
      followButtonIcon.image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
      followButtonBackground.backgroundColor = UIColor.blueAccentColor()
      followButtonBackground.layer.borderColor = UIColor.blueAccentColor().cgColor
    } else {
      followButtonLabel.textColor = UIColor.blueAccentColor()
      followButtonIcon.tintColor = UIColor.blueAccentColor()
      followButtonIcon.image = UIImage(named: "Add")?.withRenderingMode(.alwaysTemplate)
      followButtonBackground.backgroundColor = UIColor.white
      followButtonBackground.layer.borderColor = UIColor.blueAccentColor().cgColor
    }
  }

  func configureWith(_ trainer: Trainer, andState state: ProfessionalCellState = .card) {
    resetImages()
    nameLabel.text = "\(trainer.firstName) \(trainer.lastName)"
    if state == .card {
      programsBadge.text = "10 programs".uppercased()
    } else {
      programsBadge.text = trainer.category.rawValue.uppercased()
    }

    if let avatarURLString = trainer.avatarURLString,
          let avatarURL = URL(string: avatarURLString) {
      avatarImageView.kf.setImage(with: avatarURL)
    }

    bannerImageView.image = EmptyStateHelper.generateBannerImageFor(trainer)
    bannerMaskView?.isHidden = true
    if let bannerURLString = trainer.bannerURLString, let bannerURL = URL(string: bannerURLString) {
      bannerImageView.kf.setImage(with: bannerURL) { image, _, _, _ in
        self.bannerImageView.image = image
        self.bannerMaskView?.isHidden = false
      }
    }

    self.state = state
  }

  fileprivate func resetImages() {
    avatarImageView.kf.cancelDownloadTask()
    bannerImageView.kf.cancelDownloadTask()
    avatarImageView.image = nil
    bannerImageView.image = nil
  }

  fileprivate func updateWithState(_ state: ProfessionalCellState) {
    switch state {
    case .card:
      cardView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    case .normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}
