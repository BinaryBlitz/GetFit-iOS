import UIKit
import Haneke
import Reusable

class ProfileCardTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var bannerImageView: UIImageView!
  @IBOutlet weak var avatarImageView: CircleImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var settingsBadge: BadgeView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
    avatarImageView.layer.borderWidth = 5
    avatarImageView.image = nil
    avatarImageView.backgroundColor = UIColor.primaryYellowColor()
    avatarImageView.contentMode = .ScaleAspectFill
    
    bannerImageView.image = nil
    bannerImageView.backgroundColor = UIColor.blueAccentColor()
    bannerImageView.contentMode = .ScaleAspectFill
    
    settingsBadge.style = BadgeView.Style(color: .LightBlue, height: .Tall)
    settingsBadge.text = "Settings"
  }
 
  
  func configureWith(viewModel: UserPresentable) {
    nameLabel.text = viewModel.name
    
    bannerImageView.hnk_cancelSetImage()
    if let bannerURL = viewModel.coverImageURL {
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
      bannerImageView.addSubview(activityIndicator)
      activityIndicator.autoCenterInSuperview()
      bannerImageView.hnk_setImageFromURL(bannerURL)
    }
    
    avatarImageView.hnk_cancelSetImage()
    if let avatarURL = viewModel.avatarURL {
      avatarImageView.hnk_setImageFromURL(avatarURL)
    }
  }
}
