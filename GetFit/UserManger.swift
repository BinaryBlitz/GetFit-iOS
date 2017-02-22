import Realm
import RealmSwift
// Class for managing logged in user data

class UserManager {
  static let instance = UserManager()
  let realm = try! Realm()

  var currentUser: User? {
    didSet {
      guard let user = currentUser else { return }
      try? realm.write {
        realm.add(user, update: true)
      }
      LocalStorageHelper.save(user.id, forKey: .userId)
    }
  }

  var apiToken: String? {
    set {
      try? realm.write {
        currentUser?.apiToken = newValue ?? ""
      }
      print("API Token updated: \(newValue)")
    }
    get {
      return currentUser?.apiToken
    }
  }

  var deviceToken: String? {
    didSet {
      LocalStorageHelper.save(deviceToken, forKey: .deviceToken)
    }
  }

  var authenticated: Bool {
    return apiToken != nil
  }

  private init() {
    guard let userId: String? = LocalStorageHelper.loadObjectForKey(.userId) else { return }
    currentUser = realm.object(ofType: User.self, forPrimaryKey: userId)
  }
}
