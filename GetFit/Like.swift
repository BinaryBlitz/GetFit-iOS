import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate
import Moya_SwiftyJSONMapper

class Like: ALSwiftyJSONAble {
  dynamic var createdAt: Date = Date()
  dynamic var id: Int = 0
  dynamic var updatedAt: Date = Date()

  required init(jsonData: JSON) {

    guard let id = jsonData["id"].int, let createdAt = jsonData["created_at"].string, let updatedAt = jsonData["updated_at"].string else {
      return
    }
    self.id = id

    let createdAtDate = try? createdAt.date(format: .iso8601(options: .withInternetDateTimeExtended))
    self.createdAt = createdAtDate?.absoluteDate ?? Date()

    let updatedAtDate = try? updatedAt.date(format: .iso8601(options: .withInternetDateTimeExtended))
    self.updatedAt = updatedAtDate?.absoluteDate ?? Date()
  }
}
