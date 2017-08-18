import UIKit
import Kingfisher

class ProgramPreviewView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var priceBadge: BadgeView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var bannerView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()

    contentView.layer.cornerRadius = 5
    contentView.layer.borderWidth = 0.8
    contentView.layer.borderColor = UIColor.lightGray.cgColor
  }

  func configureWith(_ program: ProgramPresentable) {
    titleLabel.text = program.title
    infoLabel.text = program.workoutsCount
    priceBadge.style = BadgeView.Style(color: .lightBlue, height: .tall)
    priceBadge.text = program.price
    bannerView.kf.setImage(with: program.bannerURL)
  }
}
