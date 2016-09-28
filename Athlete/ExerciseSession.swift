import Realm
import RealmSwift
import Moya_SwiftyJSONMapper
import SwiftyJSON

class ExerciseSession: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  let sets = RealmOptional<Int>()
  let reps = RealmOptional<Int>()
  let weight = RealmOptional<Int>()
  let distance = RealmOptional<Int>()
  dynamic var completed: Bool = false
  dynamic var name: String = ""
  dynamic var videoID: String = ""
  dynamic var exersiceDescription: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init?(jsonData: JSON) {
    super.init()
    
    guard let id = jsonData["id"].int, let completed = jsonData["completed"].bool,
        let name = jsonData["exercise"]["exercise_type"]["name"].string else {
      return nil
    }
    
    self.id = id
    self.name = name
    self.completed = completed
    
    if let sets = jsonData["sets"].int {
      self.sets.value = sets
    }
    
    if let reps = jsonData["reps"].int {
      self.reps.value = reps
    }
    
    if let weight = jsonData["weight"].int {
      self.weight.value = weight
    }
    
    if let distance = jsonData["distance"].int {
      self.distance.value = distance
    }
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}
