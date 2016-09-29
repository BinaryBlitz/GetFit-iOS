import UIKit
import Reusable
import Haneke

class ChatsTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var roundedImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()

    roundedImageView.image = EmptyStateHelper.avatarPlaceholderImage
    roundUp(roundedImageView)
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    roundedImageView.hnk_cancelSetImage()
    roundedImageView.image = EmptyStateHelper.avatarPlaceholderImage
  }

  fileprivate func roundUp(_ imageView: UIImageView) {
    roundedImageView.layer.cornerRadius = roundedImageView.frame.width / 2
    roundedImageView.layer.shouldRasterize = true
    roundedImageView.clipsToBounds = true
  }

  func configureWith(_ viewModel: SubscriptionPresentable) {
    titleLabel.text = viewModel.name
    subtitleLabel.text = viewModel.lastMessage ?? "No messages"
    createdAtLabel.text = viewModel.createdAt
    if let url = viewModel.avatarImageURL {
      roundedImageView.hnk_setImageFromURL(url)
    }
  }

}
