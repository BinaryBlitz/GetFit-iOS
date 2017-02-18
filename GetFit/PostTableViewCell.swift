import UIKit
import Kingfisher
import PureLayout
import Reusable

typealias PostCellPresentable = PostPresentable & TrainerPresentable & DateTimePresentable & TextPresentable

class PostTableViewCell: UITableViewCell, NibReusable {

  //MARK: - Constants
  fileprivate let imageContentHeight: CGFloat = 208
  fileprivate let programContrentHeight: CGFloat = 100
  fileprivate let spaceBetweenTextAndContent: CGFloat = 12
  fileprivate let numberOfLinesInPostPreview = 5

  //MARK: - Base
  @IBOutlet weak var cardView: CardView!

  //MARK: - Header
  @IBOutlet weak var trainerAvatarImageView: CircleImageView!
  @IBOutlet weak var trainerNameLabel: UILabel!

  //MARK: - Body
  @IBOutlet weak var postContentLabel: UILabel!

  var contentImageView: UIImageView?
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var containerHeight: NSLayoutConstraint!
  @IBOutlet weak var containerToTextSpace: NSLayoutConstraint!

  //MARK: - Footer
  @IBOutlet weak var dateView: BadgeView!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var likesCountLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!

  enum ContentType {
    case none
    case photo(photoURL: URL)
    case trainingProgram(program: Program)
  }

  enum PostCellState {
    case normal
    case card
  }

  var state: PostCellState = .card {
    didSet {
      updateWithState(state)
    }
  }

  var liked: Bool {
    get {
      return likeButton.isSelected
    }
    set(newValue) {
      likeButton.isSelected = newValue
    }
  }

  //MARK: - Delegate

  weak var delegate: PostTableViewCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()

    contentView.backgroundColor = .lightGrayBackgroundColor()

    likeButton.setImage(UIImage(named: "Likes"), for: UIControlState())
    likeButton.setImage(UIImage(named: "LikesSelected"), for: .selected)
    likeButton.setImage(UIImage(named: "LikesSelected"), for: .highlighted)

    trainerNameLabel.textColor = UIColor.graySecondaryColor()
    layoutMargins = UIEdgeInsets.zero

    trainerAvatarImageView.image = EmptyStateHelper.avatarPlaceholderImage
  }

  //MARK: - Cell configuration

  func configureWith(_ viewModel: PostCellPresentable) {
    if let imageURL = viewModel.imageURL {
      updateContentWith(.photo(photoURL: imageURL as URL))
    } else if let program = viewModel.program {
      updateContentWith(.trainingProgram(program: program))
    } else {
      updateContentWith(.none)
    }

    postContentLabel.text = viewModel.text

    if let trainerAvatarURL = viewModel.trainerAvatarURL {
      trainerAvatarImageView.kf.setImage(with: trainerAvatarURL)
    }

    likeButton.isSelected = viewModel.liked
    trainerNameLabel.text = viewModel.trainerName

    dateView.text = viewModel.dateString

    likesCountLabel.text = viewModel.likesCount
    commentsCountLabel.text = viewModel.commentsCount
  }

  fileprivate func updateContentWith(_ type: ContentType) {
    switch type {
    case .none:
      containerHeight.constant = 0
      containerToTextSpace.constant = 0
      containerView.isHidden = true
    case .photo(let photoURL):
      containerHeight.constant = imageContentHeight
      containerToTextSpace.constant = spaceBetweenTextAndContent
      containerView.isHidden = false
      containerView.backgroundColor = UIColor.lightGray

      // create image view
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: imageContentHeight))
      self.contentImageView = imageView
      imageView.contentMode = UIViewContentMode.scaleAspectFill
      imageView.layer.masksToBounds = true
      imageView.kf.setImage(with: photoURL)
      containerView.addSubview(imageView)
      imageView.autoPinEdgesToSuperviewEdges()

    case .trainingProgram(let program):
      containerHeight.constant = programContrentHeight
      containerToTextSpace.constant = spaceBetweenTextAndContent
      containerView.isHidden = false
      containerView.backgroundColor = UIColor.lightGray
      let programView = loadProgramPreviewView()
      programView.configureWith(ProgramViewModel(program: program))
      containerView.addSubview(programView)
      programView.autoPinEdgesToSuperviewEdges()
    }
  }

  func loadProgramPreviewView() -> ProgramPreviewView {
    let nibName = String(describing: ProgramPreviewView.self)
    return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!.first as! ProgramPreviewView
  }

  //MARK: - Actions

  @IBAction func commentButtonAction(_ sender: AnyObject) {
    delegate?.didTouchCommentButton(self)
  }

  @IBAction func likeButtonAction(_ sender: AnyObject) {
    defer { delegate?.didTouchLikeButton(self) }
    likeButton.isSelected = !likeButton.isSelected

    if let likesString = likesCountLabel.text,
       let likes = Int(likesString) {
      if likeButton.isSelected {
        likesCountLabel.text = String(likes + 1)
      } else {
        likesCountLabel.text = String(likes - 1)
      }
    }
  }

  fileprivate func updateWithState(_ state: PostCellState) {
    switch state {
    case .card:
      cardView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
    case .normal:
      cardView.autoPinEdgesToSuperviewEdges()
    }
  }
}

//MARK: - Previewable

extension PostTableViewCell: Previewable {
  var displayAsPreview: Bool {
    get {
      return postContentLabel.numberOfLines != 0
    }
    set {
      postContentLabel.numberOfLines = newValue ? numberOfLinesInPostPreview : 0
    }
  }
}
