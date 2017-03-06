import Foundation
import Moya
import RealmSwift

struct PostViewModel {
  let post: Post
  let postsProvider = APIProvider<GetFit.Posts>()

  enum PostReaction {
    case like
    case dislike
  }

  func updateReaction(_ reaction: PostReaction, _ completion: (() -> Void)? = nil) -> Cancellable {
    switch reaction {
    case .like:
      addLike()
      return postsProvider.request(.createLike(postId: post.id)) { result in
        completion?()
        switch result {
        case .success(let response):
          do {
            try _ = response.filterSuccessfulStatusCodes()
            let like = try response.map(to: Like.self)
            self.addLikeId(self.post, like: like)
          } catch {
          }
        case .failure(let error):
          print(error)
        }
      }
    case .dislike:
      self.removeLike(self.post)
      return postsProvider.request(.destroyLike(postId: post.id)) { _ in completion?() }
    }
  }


  fileprivate func addLike() {
    let realm = try! Realm()
    try! realm.write {
      post.liked = true
      post.likesCount += 1
    }
  }

  fileprivate func addLikeId(_ post: Post, like: Like) {
    let realm = try! Realm()
    try! realm.write {
      post.likeId = like.id
    }
  }

  fileprivate func removeLike(_ post: Post) {
    let realm = try! Realm()
    try! realm.write {
      post.liked = false
      post.likeId = -1
      post.likesCount -= 1
    }

  }
}

// MARK: - PostPresentable

extension PostViewModel: PostPresentable {
  var imageURL: URL? {
    guard let imageURLString = post.imageURLString,
          let url = URL(string: imageURLString) else {
      return nil
    }

    return url
  }

  var likesCount: String {
    return post.likesCount.format()
  }

  var commentsCount: String {
    return post.commentsCount.format()
  }

  var liked: Bool {
    return post.liked
  }

  var program: Program? {
    return post.program
  }
}

// MARK: - TextPresentable

extension PostViewModel: TextPresentable {
  var text: String {
    return post.content
  }
}

// MARK: - TrainerPresentable

extension PostViewModel: TrainerPresentable {
  var trainerAvatarURL: URL? {
    guard let trainer = post.trainer,
          let avatarURLString = trainer.avatarURLString else {
      return nil
    }

    return URL(string: avatarURLString)
  }

  var trainerName: String {
    guard let trainer = post.trainer else {
      return ""
    }

    return "\(trainer.firstName) \(trainer.lastName)"
  }
}

// MARK: - DateTimePresentable

extension PostViewModel: DateTimePresentable {
  var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"

    return dateFormatter.string(from: post.dateCreated as Date)
  }
}
