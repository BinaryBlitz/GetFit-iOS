import Realm
import RealmSwift
// Class for managing logged in user data

struct UserManager {

  static var currentUser: User? {
    get {
      let realm = try! Realm()
      let userId: Int? = LocalStorageHelper.loadObjectForKey(.userId)
      guard userId != nil else { return nil }
      return realm.object(ofType: User.self, forPrimaryKey: userId)
    }
    set {
      guard let user = newValue else {
        LocalStorageHelper.save(nil, forKey: .userId)
        return
      }
      LocalStorageHelper.save(user.id, forKey: .userId)
    }
  }

  static var apiToken: String? {
    get {
      return LocalStorageHelper.loadObjectForKey(.apiToken)
    }
    set {
      LocalStorageHelper.save(newValue, forKey: .apiToken)
      print("API Token updated: \(newValue)")
    }
  }

  static var deviceToken: String? {
    didSet {
      LocalStorageHelper.save(deviceToken, forKey: .deviceToken)
    }
  }

  static func logout() {
    apiToken = nil
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
  }

  static var authenticated: Bool {
    return apiToken != nil
  }
}
