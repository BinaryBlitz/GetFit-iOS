import UIKit
import Reusable

class ChatsTableViewCell: UITableViewCell, NibReusable {
  
  @IBOutlet weak var chatAvatarImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var lastUpdateDateLabel: UILabel!
  

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureWith(viewModel: ) {
    
  }
  
}
