import UIKit
import Reusable

class ExerciseVideoTableViewCell: UITableViewCell, NibReusable {

  @IBOutlet weak var videoTitleLabel: UILabel!
  @IBOutlet weak var videoDurtionLabel: UILabel!
  @IBOutlet weak var previewImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func confugure() {

  }
}
