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

  func updateReaction(_ reaction: PostReaction) -> Cancellable {
    return postsProvider.request(.createLike(postId: post.id)) { result in
      switch result {
      case .success(let response):
        do {
          try _ = response.filterSuccessfulStatusCodes()
          print("yay! new like")
        } catch {
          self.addLikeToUploadQueueFor(self.post)
        }
      case .failure(let error):
        print(error)
        self.addLikeToUploadQueueFor(self.post)
      }
    }
  }

  fileprivate func addLikeToUploadQueueFor(_ post: Post) {
    let realm = try! Realm()
    try! realm.write {
      let like = Like()
      realm.add(like)
      post.like = like
    }
  }
}

//MARK: - PostPresentable

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
    return post.likeId != -1
  }

  var program: Program? {
    return post.program
  }
}

//MARK: - TextPresentable

extension PostViewModel: TextPresentable {
  var text: String {
    return post.content
  }
}

//MARK: - TrainerPresentable

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

//MARK: - DateTimePresentable

extension PostViewModel: DateTimePresentable {
  var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"

    return dateFormatter.string(from: post.dateCreated as Date)
  }
}
