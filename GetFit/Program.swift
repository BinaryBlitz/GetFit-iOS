import SwiftyJSON
import Realm
import RealmSwift
import Moya_SwiftyJSONMapper

class Program: Object, ALSwiftyJSONAble {

  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var programPreview: String = ""
  dynamic var programDescription: String = ""
  dynamic var bannerURLString: String? = ""
  dynamic var trainer: Trainer?
  dynamic var type: String = ""
  dynamic var programType: ProgramType? = nil
  dynamic var price: Int = 0
  dynamic var duration: Int = 0
  dynamic var purchaseId: Int = -1
  dynamic var workoutsCount: Int = 0
  dynamic var usersCount: Int = 0
  dynamic var rating: Double = 0

  override static func primaryKey() -> String? {
    return "id"
  }

  required init() {
    super.init()
  }

  required init?(jsonData: JSON) {
    super.init()

    guard let id = jsonData["id"].int, let name = jsonData["name"].string, let preview = jsonData["preview"].string,
          let price = jsonData["price"].int, let programDescription = jsonData["description"].string else {
      return nil
    }

    self.id = id
    self.name = name
    self.programPreview = preview
    self.programDescription = programDescription
    self.price = price

    if let bannerURLPath = jsonData["banner_url"].string {
      self.bannerURLString = bannerURLPath
    }

    if let duration = jsonData["duration"].int {
      self.duration = duration
    }

    if let type = jsonData["program_type"]["name"].string {
      self.type = type
    }

    if let purchaseId = jsonData["purchase_id"].int {
      self.purchaseId = purchaseId
    }

    if let trainer = Trainer(jsonData: jsonData["trainer"]) {
      self.trainer = trainer
      let realm = try! Realm()
      try! realm.write {
        realm.add(trainer, update: true)
      }
    }

    if let workoutsCount = jsonData["workouts_count"].int {
      self.workoutsCount = workoutsCount
    }

    if let usersCount = jsonData["users_count"].int {
      self.usersCount = usersCount
    }

    if let rating = jsonData["rating"].double {
      self.rating = rating
    }

    if let programType = ProgramType(jsonData: jsonData["program_type"]) {
      self.programType = programType
      let realm = try! Realm()
      try! realm.write {
        realm.add(programType, update: true)
      }
    }

    let workouts = jsonData["workouts"].flatMap { (_, workoutJSON) -> Workout? in
      let workout = Workout(jsonData: workoutJSON)
      workout?.programId = self.id
      return workout
    }

    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(Workout.self).filter("programId == \(self.id)"))
      realm.add(workouts, update: true)
    }
  }

  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
