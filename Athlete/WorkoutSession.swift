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
  dynamic var date: NSDate = NSDate()
  dynamic var position: Int = 0
  dynamic var exercisesCount: Int = 0
  var exercises = List<ExerciseSession>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init?(jsonData: JSON) {
    super.init()
    
    guard let id = jsonData["id"].int, workoutID = jsonData["workout_id"].int,
        scheduledFor = jsonData["scheduled_for"].string else {
      return nil
    }
    
    self.id = id
    self.workoutID = workoutID
    self.date = scheduledFor.toDate(.ISO8601Format(.Date))!
    
    guard let workoutName = jsonData["workout"]["name"].string,
      duration = jsonData["workout"]["duration"].int,
      exercisesCount = jsonData["workout"]["exercises_count"].int,
      programName = jsonData["workout"]["program"]["name"].string,
      programID = jsonData["workout"]["program"]["id"].int
    else {
        return nil
    }
    
    if let position = jsonData["workout"]["position"].int {
      self.position = position
    }
    
    if let completed = jsonData["completed"].bool {
      self.completed = completed
    }
    
    self.workoutID = workoutID
    self.workoutName = workoutName
    self.duration = duration
    self.exercisesCount = exercisesCount
    self.programId = programID
    self.programName = programName
  }
  
  func updateWith(workout: Workout) {
    self.workoutID = workout.id
    self.workoutName = workout.name
    self.programId = workout.programId
    self.programName = workout.programName
    self.position = workout.position
    self.duration = workout.duration
    self.exercisesCount = workout.exercisesCount
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}