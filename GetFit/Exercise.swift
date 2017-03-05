import Realm
import RealmSwift
import SwiftyJSON

class Exercise: Object, JSONSerializable {
  dynamic var name: String = ""
  dynamic var tips: String = ""

  required init() {
    super.init()
  }

  required init?(json: JSON) {
    super.init()

    guard let name = json["exercise_type"]["name"].string else {
      return nil
    }

    if let tips = json["exercise_type"]["tips"].string {
      self.tips = tips
    }

    self.name = name
  }

  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
