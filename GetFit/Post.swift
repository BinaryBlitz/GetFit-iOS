import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate
import Moya_SwiftyJSONMapper

class Post: Object, ALSwiftyJSONAble {

  dynamic var id: Int = 0
  dynamic var content: String = ""
  dynamic var trainer: Trainer?
  dynamic var program: Program?
  dynamic var imageURLString: String?
  dynamic var dateCreated: Date = Date()
  dynamic var likesCount: Int = 0
  dynamic var commentsCount: Int = 0
  dynamic var likeId: Int = -1
  var like: Like?
  let comments = List<Comment>()

  required init?(jsonData: JSON) {
    super.init()

    guard let id = jsonData["id"].int, let content = jsonData["content"].string, let createdAt = jsonData["created_at"].string else {
      return nil
    }

    self.id = id
    self.content = content
    self.dateCreated = createdAt.toDate(.ISO8601Format(.Extended)) ?? NSDate()

    if let likesCount = jsonData["likes_count"].int {
      self.likesCount = likesCount
    }

    if let commentsCount = jsonData["comments_count"].int {
      self.commentsCount = commentsCount
    }

    if let likeId = jsonData["like_id"].int {
      self.likeId = likeId
    }

    if let url = jsonData["image_url"].string {
      self.imageURLString = url
    }

    if let trainer = Trainer(jsonData: jsonData["trainer"]) {
      self.trainer = trainer
      let realm = try! Realm()
      try! realm.write {
        realm.add(trainer, update: true)
      }
    }
    
    if let program = Program(jsonData: jsonData["program"]) {
      self.program = program
      let realm = try! Realm()
      try! realm.write {
        realm.add(program, update: true)
      }
    }
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
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

