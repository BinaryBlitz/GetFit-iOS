import UIKit
import Kingfisher
import PureLayout
import Reusable

protocol ProfessionalCellDelegate: class {
  func professionalCell(_ cell: ProfessionalTableViewCell, didChangeFollowingTo: Bool)
  func avatarViewDidTap()
}

extension ProfessionalCellDelegate {
  func avatarViewDidTap() { }
}

class ProfessionalTableViewCell: UITableViewCell, NibReusable {

  let animationDuration = 0.2

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


  var followersCount: Int = 0 {
    didSet {
      followersLabel.text = "\(followersCount)"
    }
  }

  weak var delegate: ProfessionalCellDelegate?

  fileprivate var following: Bool = false {
    didSet {
      updateFollowingStatus(following)
    }
  }

  var followingIsHighlighted: Bool = false {
    didSet {
      updateHighlightedStatus(followingIsHighlighted)
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

    avatarImageView.isUserInteractionEnabled = true
    avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarViewDidTap)))

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
    button.addTarget(self, action: #selector(followButtonDidTouch(_:)), for: .touchDown)
    button.addTarget(self, action: #selector(followButtonDidEndTouch(_:)), for: .touchDragExit)

    followButtonBackground.layer.borderWidth = 1
    followButtonBackground.layer.cornerRadius = 2
    followButtonLabel.text = "follow".uppercased()
  }

  func followButtonDidTouch(_ sender: UIButton) {
    followingIsHighlighted = true
  }

  func followButtonDidEndTouch(_ sender: UIButton) {
    followingIsHighlighted = false
  }

  func followButtonAction(_ sender: UIButton) {
    followingIsHighlighted = false
    following = !following
    delegate?.professionalCell(self, didChangeFollowingTo: following)
  }


  func updateHighlightedStatus(_ isHighlighted: Bool) {
    UIView.animate(withDuration: animationDuration, animations: { [weak self] in
      guard let `self` = self else { return }
      if isHighlighted {
        self.followButtonLabel.textColor = UIColor.white
        self.followButtonIcon.tintColor = UIColor.white
        self.followButtonBackground.backgroundColor = UIColor.blueAccentColor()
        self.followButtonBackground.layer.borderColor = UIColor.blueAccentColor().cgColor
      } else {
        self.followButtonLabel.textColor = UIColor.blueAccentColor()
        self.followButtonIcon.tintColor = UIColor.blueAccentColor()
        self.followButtonBackground.backgroundColor = UIColor.white
        self.followButtonBackground.layer.borderColor = UIColor.blueAccentColor().cgColor
      }
    }, completion: nil)
  }

  func updateFollowingStatus(_ following: Bool) {
    if following {
      followersCount += 1
      followButtonLabel.textColor = UIColor.white
      followButtonIcon.tintColor = UIColor.white
      followButtonIcon.image = UIImage(named: "Checkmark")?.withRenderingMode(.alwaysTemplate)
      followButtonBackground.backgroundColor = UIColor.blueAccentColor()
      followButtonBackground.layer.borderColor = UIColor.blueAccentColor().cgColor
    } else {
      followersCount -= 1
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
      programsBadge.text = "\(trainer.programsCount) programs".uppercased()
    } else {
      programsBadge.text = trainer.category.rawValue.uppercased()
    }

    descriptionLabel.text = trainer.info

    if let avatarURLString = trainer.avatarURLString,
       let avatarURL = URL(string: avatarURLString) {
      avatarImageView.kf.setImage(with: avatarURL)
    } else {
      avatarImageView.image = nil
    }

    following = trainer.following

    followersCount = trainer.followersCount
    ratingLabel.text = "\(Int(trainer.rating))"

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

  func avatarViewDidTap() {
    delegate?.avatarViewDidTap()
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
