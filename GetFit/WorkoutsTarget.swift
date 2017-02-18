import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {

  public enum Workouts {
    case index
  }

}

extension GetFit.Workouts: TargetType {

  public var path: String {
    return "/workouts"
  }

  public var method: Moya.Method {
    return .get
  }

  public var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  public var parameters: [String: Any]? {
    return nil
  }

}
