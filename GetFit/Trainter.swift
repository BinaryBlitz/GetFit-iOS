import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate
import Moya_SwiftyJSONMapper

class Trainer: Object, ALSwiftyJSONAble {

  dynamic var id: Int = 0
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var info: String = ""
  dynamic var email: String = ""
  dynamic var followingId: Int = -1
  dynamic var following: Bool = false {
    didSet {
      guard let realm = self.realm, !following else { return }
      try? realm.write {
        self.followingId = -1
      }
    }
  }
  dynamic var categoryValue: String = TrainerCategory.Coach.rawValue
  dynamic var avatarURLString: String? = ""
  dynamic var bannerURLString: String? = ""
  dynamic var programsCount: Int = 0
  dynamic var followersCount: Int = 0
  dynamic var rating: Double = 0

  var category: TrainerCategory {
    get {
      return TrainerCategory(rawValue: categoryValue)!
    }
    set(newCategory) {
      categoryValue = newCategory.rawValue
    }
  }

  var name: String {
    return "\(firstName) \(lastName)"
  }

  let posts = LinkingObjects(fromType: Post.self, property: "trainer")

  let programs = LinkingObjects(fromType: Program.self, property: "trainer")

  override static func primaryKey() -> String? {
    return "id"
  }

  required init() {
    super.init()
  }

  required init?(jsonData: JSON) {
    super.init()

    guard let id = jsonData["id"].int, let firstName = jsonData["first_name"].string,
          let lastName = jsonData["last_name"].string else {
      return nil
    }

    self.id = id
    self.firstName = firstName
    self.lastName = lastName

    if let followingId = jsonData["following_id"].int {
      self.followingId = followingId
      self.following = followingId != -1
    } else {
      self.followingId = -1
      self.following = false
    }

    if let description = jsonData["description"].string {
      self.info = description
    }

    if let avatarURLPath = jsonData["avatar_url"].string {
      self.avatarURLString = avatarURLPath
    }

    if let bannerURLPath = jsonData["banner_url"].string {
      self.bannerURLString = bannerURLPath
    }

    if let followersCount = jsonData["followers_count"].int {
      self.followersCount = followersCount
    }

    if let programsCount = jsonData["programs_count"].int {
      self.programsCount = programsCount
    }

    if let rating = jsonData["rating"].double {
      self.rating = rating
    }
  }

  required init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
