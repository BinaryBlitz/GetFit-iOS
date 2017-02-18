import Realm
import RealmSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper

class Workout: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var duration: Int = 0
  dynamic var programName: String = ""
  dynamic var programId: Int = 0
  dynamic var position: Int = 0
  dynamic var exercisesCount: Int = 0
  let exercises = List<Exercise>()
  
  override static func primaryKey() -> String? {
    return "id"
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

  required init?(jsonData: JSON) {
    super.init()
    
    guard let id = jsonData["id"].int else {
      return nil
    }
    
    self.id = id
    
    if let name = jsonData["name"].string {
      self.name = name
    } else {
      self.name = "workout name"
    }
    
    if let exercisesCount = jsonData["exercises_count"].int {
      self.exercisesCount = exercisesCount
    }
    
    if let programId = jsonData["program"]["id"].int {
      self.programId = programId
    }
    
    if let programName = jsonData["program"]["name"].string {
      self.programName = programName
    }
    
    if let position = jsonData["position"].int {
      self.position = position
    }
    
    if let duration = jsonData["duration"].int {
      self.duration = duration
    }
    
    let exercises = jsonData["exercises"].flatMap { (_, exerciseJSON) -> Exercise? in
      return Exercise(json: exerciseJSON)
    }
    
    let realm = try! Realm()
    try! realm.write {
      realm.add(exercises)
      self.exercises.removeAll()
      self.exercises.append(objectsIn: exercises)
    }
  }
}
