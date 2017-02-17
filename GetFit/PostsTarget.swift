import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {
  
  public enum Posts {
    case index
    case createLike(postId: Int)
    case getComments(postId: Int)
    case createComment(comment: Comment, postId: Int)
  }
  
}

extension GetFit.Posts: TargetType {
  
  public var path: String {
    switch self {
    case .index:
      return "/posts"
    case .createLike(let postId):
      return "/posts/\(postId)/likes"
    case .getComments(let postId):
      return "/posts/\(postId)/comments"
    case let .createComment(_, postId):
      return "/posts/\(postId)/comments"
    }
  }

  public var parameterEncoding: ParameterEncoding {
    switch self {
    case .index, .getComments(_):
      return URLEncoding.default
    case .createComment(_, _), .createLike(_):
      return JSONEncoding.default
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .index, .getComments(_):
      return .get
    case .createComment(_, _), .createLike(_):
      return .post
    }
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .index, .getComments(_), .createLike(_):
      return nil
    case let .createComment(comment, _):
      return ["comment": ["content": comment.content]]
    }
  }
}