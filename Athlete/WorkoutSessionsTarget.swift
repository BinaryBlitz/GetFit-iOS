import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan
import SwiftDate

extension GetFit {
  
  enum WorkoutSessions {
    case index
    case create(sessions: [WorkoutSession])
    case exerciseSessions(workoutSession: Int)
    case updateExerciseSession(session: ExerciseSession)
  }
  
}

extension GetFit.WorkoutSessions: TargetType {
  
  var path: String {
    switch self {
    case .index:
      return "/workout_sessions"
    case .create(_):
      return "/user"
    case .exerciseSessions(let workoutSession):
      return "/workout_sessions/\(workoutSession)/exercise_sessions"
    case .updateExerciseSession(let session):
      return "/exercise_sessions/\(session.id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .index, .exerciseSessions(_):
      return .GET
    case .create(_), .updateExerciseSession(_):
      return .PATCH
    }
  }
  
  var parameters: [String: AnyObject]? {
    switch self {
    case .index, .exerciseSessions(_):
      return nil
    case .create(let workoutSessions):
      let sessions = workoutSessions.map { session -> [String: AnyObject] in
        return ["workout_id": session.workoutID as AnyObject,
            "scheduled_for": session.date.toString(.ISO8601Format(.Date))!
        ]
      }
      return ["user": ["workout_sessions_attributes": sessions]]
    case .updateExerciseSession(let session):
      let sessionData = ["completed": session.completed]
      return ["exercise_session": sessionData as AnyObject]
    }
  }
  
}
