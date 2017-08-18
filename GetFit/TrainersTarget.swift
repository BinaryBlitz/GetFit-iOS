import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {

  public enum Trainers {
    case index(filter: TrainersFilter)
    case show(id: Int)
    case programs(trainerId: Int)
    case createFollowing(trainerId: Int)
    case destroyFollowing(followingId: Int)
    case createRating(trainerId: Int, value: Int, content: String)
  }

}

extension GetFit.Trainers: TargetType {

  public var path: String {
    switch self {
    case .index(_):
      return "/trainers"
    case .show(let id):
      return "/trainers/\(id)"
    case .programs(let trainerId):
      return "/trainers/\(trainerId)/programs"
    case .createFollowing(let trainerId):
      return "/trainers/\(trainerId)/followings"
    case .destroyFollowing(let followingId):
      return "/followings/\(followingId)"
    case .createRating(let trainerId, _, _):
      return "/trainers/\(trainerId)/ratings"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .createFollowing(_), .createRating(_, _, _):
      return .post
    case .destroyFollowing(_):
      return .delete
    default:
      return .get
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }

  public var parameters: [String: Any]? {
    switch self {
    case .index(let filter):
      return ["category": filter.category.rawValue as Any]
    case .show(_), .programs(_), .createFollowing(_), .destroyFollowing(_):
      return nil
    case .createRating(_, let value, let content):
      let rating = ["value": value as Any, "content": content as Any]
      return ["rating": rating as Any]
    }
  }

}
