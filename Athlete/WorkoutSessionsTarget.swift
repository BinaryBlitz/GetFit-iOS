import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan
import SwiftDate

extension GetFit {
  
  enum WorkoutSessions {
    case Index
    case Create(sessions: [WorkoutSession])
    case ExerciseSessions(workoutSession: Int)
    case UpdateExerciseSession(session: ExerciseSession)
  }
  
}

extension GetFit.WorkoutSessions: TargetType {
  
  var path: String {
    switch self {
    case .Index:
      return "/workout_sessions"
    case .Create(_):
      return "/user"
    case .ExerciseSessions(let workoutSession):
      return "/workout_sessions/\(workoutSession)/exercise_sessions"
    case .UpdateExerciseSession(let session):
      return "/exercise_sessions/\(session.id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .Index, .ExerciseSessions(_):
      return .GET
    case .Create(_), .UpdateExerciseSession(_):
      return .PATCH
    }
  }
  
  var parameters: [String: AnyObject]? {
    switch self {
    case .Index, .ExerciseSessions(_):
      return nil
    case .Create(let workoutSessions):
      let sessions = workoutSessions.map { session -> [String: AnyObject] in
        return ["workout_id": session.workoutID,
            "scheduled_for": session.date.toString(.ISO8601Format(.Date))!
        ]
      }
      return ["user": ["workout_sessions_attributes": sessions]]
    case .UpdateExerciseSession(let session):
      let sessionData = ["completed": session.completed]
      return ["exercise_session": sessionData]
    }
  }
  
}
