import Realm
import RealmSwift
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

open class Message: Object, ALSwiftyJSONAble {

  dynamic var id: Int = 0
  dynamic var content: String?
  dynamic var createdAt: Date = Date()
  fileprivate dynamic var categoryValue: String?

  var category: Category? {
    get {
      guard let value = categoryValue else { return nil }

      return Category(rawValue: value)
    }
    set {
      guard let category = newValue else {
        categoryValue = nil
        return
      }

      categoryValue = category.rawValue
    }
  }

  enum Category: String {
    case User = "user"
    case Trainer = "trainer"
  }

  public required init() {
    super.init()
  }

  public required init?(jsonData: JSON) {
    super.init()

    guard let id = jsonData["id"].int, let content = jsonData["content"].string,
          let createdAtString = jsonData["created_at"].string else {
      return nil
    }

    self.id = id
    self.content = content
    if let date = try? createdAtString.date(format: .extended).absoluteDate {
      self.createdAt = date
    } else {
      return nil
    }

    if let categoryValue = jsonData["category"].string, let category = Category(rawValue: categoryValue) {
      self.category = category
    }
  }

  required public init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required public init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
