protocol PostTableViewCellDelegate: class {
  func didTouchLikeButton(_ cell: PostTableViewCell)
  func didTouchImageView(_ cell: PostTableViewCell)
  func didTouchCommentButton(_ cell: PostTableViewCell)
  func didTouchProgramView(_ program: Program)
}

extension PostTableViewCellDelegate {

  func didTouchLikeButton(_ cell: PostTableViewCell) {
    print("like button")
  }

  func didTouchProgramView(_ program: Program) {

  }

  func didTouchImageView(_ cell: PostTableViewCell) {
    
  }

  func didTouchCommentButton(_ cell: PostTableViewCell) {
    print("comment button")
  }
}
