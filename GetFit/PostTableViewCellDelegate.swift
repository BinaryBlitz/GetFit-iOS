protocol PostTableViewCellDelegate: class {
  func didTouchLikeButton(_ cell: PostTableViewCell)
  func didTouchCommentButton(_ cell: PostTableViewCell)
}

extension PostTableViewCellDelegate {
  
  func didTouchLikeButton(_ cell: PostTableViewCell) {
    print("like button")
  }
  
  func didTouchCommentButton(_ cell: PostTableViewCell) {
    print("comment button")
  }
}

