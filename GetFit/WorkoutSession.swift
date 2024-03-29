import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate
import Moya_SwiftyJSONMapper

class WorkoutSession: Object, ALSwiftyJSONAble {

  dynamic var id: Int = 0
  dynamic var workoutID: Int = 0
  dynamic var workoutName: String = ""
  dynamic var duration: Int = 0
  dynamic var programName: String = ""
  dynamic var programId: Int = 0
  dynamic var completed: Bool = false
  dynamic var date: Date = Date()
  dynamic var position: Int = 0
  dynamic var programTips: String = ""
  dynamic var exercisesCount: Int = 0
  dynamic var synced: Bool = true
  var exercises = List<ExerciseSession>()

  override static func primaryKey() -> String? {
    return "id"
  }

  required init?(jsonData: JSON) {
    super.init()

    guard let id = jsonData["id"].int, let workoutID = jsonData["workout_id"].int,
          let scheduledFor = jsonData["scheduled_for"].string else {
      return nil
    }

    self.id = id
    self.workoutID = workoutID
    let date = try? scheduledFor.date(format: .iso8601(options: .withFullDate)).absoluteDate
    self.date = date ?? Date()

    guard let workoutName = jsonData["workout"]["name"].string,
          let duration = jsonData["workout"]["duration"].int,
          let exercisesCount = jsonData["workout"]["exercises_count"].int,
          let programName = jsonData["workout"]["program"]["name"].string,
          let programID = jsonData["workout"]["program"]["id"].int
      else {
      return nil
    }

    if let position = jsonData["workout"]["position"].int {
      self.position = position
    }

    if let completed = jsonData["completed"].bool {
      self.completed = completed
    }

    if let programTips = jsonData["workout"]["tips"].string {
      self.programTips = programTips
    }


    self.workoutID = workoutID
    self.workoutName = workoutName
    self.duration = duration
    self.exercisesCount = exercisesCount
    self.programId = programID
    self.programName = programName
  }

  func updateWith(_ workout: Workout) {
    self.workoutID = workout.id
    self.workoutName = workout.name
    self.programId = workout.programId
    self.programName = workout.programName
    self.position = workout.position
    self.duration = workout.duration
    self.exercisesCount = workout.exercisesCount
  }

  required init() {
    super.init()
  }

  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
