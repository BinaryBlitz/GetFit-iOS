import Foundation
import Realm
import RealmSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper
import SwiftDate

public class Subscription: Object, ALSwiftyJSONAble {
  
  dynamic var id: Int = 0
  dynamic var lastMessage: Message?
  dynamic var trainerId: Int = 0
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
    
    guard let id = jsonData["id"].int, trainerId = jsonData["trainer_id"].int,
          lastMessage = Message(jsonData: jsonData["message_preview"]),
          createdAtString = jsonData["created_at"].string else {
        return nil
    }
    
    self.id = id
    self.trainerId = trainerId
    self.lastMessage = lastMessage
    if let date = createdAtString.toDate(DateFormat.ISO8601Format(.Extended)) {
      self.createdAt = date
    }
  }
}
