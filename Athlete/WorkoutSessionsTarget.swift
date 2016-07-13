import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {
  
  public enum WorkoutSessions {
    case Index
  }
  
}

extension GetFit.WorkoutSessions: TargetType {
  
  public var path: String {
    return "/workout_sessions"
  }
  
  public var method: Moya.Method {
    return .GET
  }
  
  public var parameters: [String: AnyObject]? {
    return nil
  }
  
}
