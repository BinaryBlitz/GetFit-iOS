import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {

  public enum Trainers {
    case index(filter: TrainersFilter)
    case show(id: Int)
    case programs(trainerId: Int)
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
    }
  }

  public var method: Moya.Method {
    return .get
  }

  public var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }


  public var parameters: [String: Any]? {
    switch self {
    case .index(let filter):
      return ["category": filter.category.rawValue as Any]
    case .show(_), .programs(_):
      return nil
    }
  }

}
