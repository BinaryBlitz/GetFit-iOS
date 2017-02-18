import RealmSwift

class ProgramType: Object {

  dynamic var id: Int = 0
  dynamic var name: String = ""

  override static func primaryKey() -> String? {
    return "id"
  }
}
