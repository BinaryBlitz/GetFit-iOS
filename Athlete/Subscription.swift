import Foundation
import Realm
import RealmSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

open class Subscription: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  dynamic var lastMessage: Message?
  dynamic var trainer: Trainer!
  dynamic var createdAt: Date = Date()
  let messages = List<Message>()
  
  open override static func primaryKey() -> String? {
    return "id"
  }
  
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
    
    guard let id = jsonData["id"].int, let trainerId = jsonData["trainer_id"].int,
          let createdAtString = jsonData["created_at"].string else {
        return nil
    }
    
    self.id = id
    let realm = try! Realm()
    if let trainer = realm.objectForPrimaryKey(Trainer.self, key: trainerId) {
      self.trainer = trainer
    } else if let trainer = Trainer(jsonData: jsonData["trainer"]) {
      self.trainer = trainer
    } else {
      return nil
    }
    
    if let lastMessage = Message(jsonData: jsonData["message_preview"]) {
      self.lastMessage = lastMessage
    }
    
    if let date = createdAtString.toDate(DateFormat.ISO8601Format(.Extended)) {
      self.createdAt = date
    }
  }
}
