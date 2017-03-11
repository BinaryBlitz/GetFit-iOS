import Realm
import RealmSwift
// Class for managing logged in user data

struct UserManager {
  static var currentUser: User?

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
