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
    case updateWorkoutSession(session: WorkoutSession)
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
    case .updateWorkoutSession(let workoutSession):
      return "/workout_sessions/\(workoutSession.id)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .index, .exerciseSessions(_):
      return .get
    case .create(_), .updateExerciseSession(_), .updateWorkoutSession(_):
      return .patch
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }

  var parameters: [String: Any]? {
    switch self {
    case .index, .exerciseSessions(_):
      return nil
    case .create(let workoutSessions):
      let sessions = workoutSessions.map { session -> [String: Any] in
        return ["workout_id": session.workoutID as AnyObject,
                "scheduled_for": session.date.iso8601(opts: .withInternetDateTimeExtended)
        ]
      }
      return ["user": ["workout_sessions_attributes": sessions]]
    case .updateExerciseSession(let session):
      let sessionData = ["completed": session.completed]
      return ["exercise_session": sessionData as AnyObject]
    case .updateWorkoutSession(let workoutSession):
      let sessionData = ["completed": workoutSession.completed, "scheduled_for": workoutSession.date.iso8601(opts: .withInternetDateTimeExtended)] as [String : Any]
      return ["workout_session": sessionData as AnyObject]
    }
  }

}
