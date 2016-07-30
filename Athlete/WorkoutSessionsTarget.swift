import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan
import SwiftDate

extension GetFit {
  
  enum WorkoutSessions {
    case Index
    case Create(sessions: [WorkoutSession])
  }
  
}

extension GetFit.WorkoutSessions: TargetType {
  
  var path: String {
    switch self {
    case .Index:
      return "/workout_sessions"
    case .Create(_):
      return "/user"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .Index:
      return .GET
    case .Create(_):
      return .PATCH
    }
  }
  
  var parameters: [String: AnyObject]? {
    switch self {
    case .Index:
      return nil
    case .Create(let workoutSessions):
      let sessions = workoutSessions.map { session -> [String: AnyObject] in
        return ["workout_id": session.workoutID,
            "scheduled_for": session.date.toString(.ISO8601Format(.Date))!
        ]
      }
      return ["user": ["workout_sessions_attributes": sessions]]
    }
  }
  
}
