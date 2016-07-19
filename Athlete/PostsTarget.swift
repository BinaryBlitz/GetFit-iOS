import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {
  
  public enum Posts {
    case Index
    case CreateLike(postId: Int)
    case GetComments(postId: Int)
    case CreateComment(comment: Comment, postId: Int)
  }
  
}

extension GetFit.Posts: TargetType {
  
  public var path: String {
    switch self {
    case .Index:
      return "/posts"
    case .CreateLike(let postId):
      return "/posts/\(postId)/likes"
    case .GetComments(let postId):
      return "/posts/\(postId)/comments"
    case let .CreateComment(_, postId):
      return "/posts/\(postId)/comments"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .Index, .GetComments(_):
      return .GET
    case .CreateComment(_, _), .CreateLike(_):
      return .POST
    }
  }
  
  public var parameters: [String: AnyObject]? {
    switch self {
    case .Index, .GetComments(_), .CreateLike(_):
      return nil
    case let .CreateComment(comment, _):
      return ["comment": ["content": comment.content]]
    }
  }
}