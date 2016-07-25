import Realm
import RealmSwift
import Moya_SwiftyJSONMapper
import SwiftyJSON
import SwiftDate

public class Message: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  dynamic var content: String?
  dynamic var createdAt: NSDate = NSDate()
  
  public required init() {
    super.init()
  }

  public required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  public required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
  
  public required init?(jsonData: JSON) {
    super.init()
    
    guard let id = jsonData["id"].int, content = jsonData["content"].string,
        createdAtString = jsonData["created_at"].string else {
      return nil
    }
    
    self.id = id
    self.content = content
    if let date = createdAtString.toDate(.ISO8601Format(.Extended)) {
      self.createdAt = date
    } else {
      return nil
    }
  }
}
