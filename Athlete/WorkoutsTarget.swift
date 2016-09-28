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
    return .GET
  }
  
  public var parameters: [String: AnyObject]? {
    return nil
  }
  
}
