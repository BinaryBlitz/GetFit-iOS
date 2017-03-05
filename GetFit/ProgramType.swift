import RealmSwift
import Realm
import SwiftyJSON
import Moya_SwiftyJSONMapper

class ProgramType: Object, ALSwiftyJSONAble {

  dynamic var id: Int = 0
  dynamic var name: String = ""

  override static func primaryKey() -> String? {
    return "id"
  }

  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }

  required init() {
    super.init()
  }

  required init?(jsonData: JSON) {
    super.init()

    if let id = jsonData["id"].int {
      self.id = id
    }

    if let name = jsonData["name"].string {
      self.name = name
    }
  }

}
