import Foundation
import RealmSwift

struct LocalStorageHelper {

  enum StorageKey: String {
    // TODO: save api token to the keychain
    case apiToken
    case deviceToken
    case shouldUpdateDeviceToken
  }

  static func save(_ object: Any?, forKey key: StorageKey) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(object, forKey: key.rawValue)
  }

  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    if key == StorageKey.apiToken {
      let realm = try! Realm()
      if let user = realm.objects(User.self).first { return user.apiToken as? T }
    }

    let userDefaults = UserDefaults.standard
    let object = userDefaults.object(forKey: key.rawValue)
    return object as? T
  }
}
