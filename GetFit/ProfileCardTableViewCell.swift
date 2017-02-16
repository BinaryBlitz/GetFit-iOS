import UIKit
import Kingfisher
import Reusable

class ProfileCardTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var avatarImageView: CircleImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var settingsBadge: BadgeView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    avatarImageView.layer.borderColor = UIColor.white.cgColor
    avatarImageView.layer.borderWidth = 5
    avatarImageView.image = EmptyStateHelper.avatarPlaceholderImage
    avatarImageView.backgroundColor = UIColor.primaryYellowColor()
    avatarImageView.contentMode = .scaleAspectFill
    
    bannerImageView.image = nil
    bannerImageView.backgroundColor = UIColor.blueAccentColor()
    bannerImageView.contentMode = .scaleAspectFill
    
    settingsBadge.style = BadgeView.Style(color: .lightBlue, height: .tall)
    settingsBadge.text = "Settings"
  }
 
  
  func configureWith(_ viewModel: UserPresentable) {
    nameLabel.text = viewModel.name
    
    bannerImageView.kf.cancelDownloadTask()
    if let bannerURL = viewModel.coverImageURL {
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
      bannerImageView.addSubview(activityIndicator)
      activityIndicator.autoCenterInSuperview()
      bannerImageView.kf.setImage(with: bannerURL)
    }
    
    avatarImageView.kf.cancelDownloadTask()
    if let avatarURL = viewModel.avatarURL {
      avatarImageView.kf.setImage(with: avatarURL)
    }
  }
}
