import Foundation
import RealmSwift
import KeychainAccess

struct LocalStorageHelper {

  enum StorageKey: String {
    // TODO: save api token to the keychain
    case apiToken
    case deviceToken
    case shouldUpdateDeviceToken
  }

  static func save(_ object: Any?, forKey key: StorageKey) {
    if key == .apiToken, let tokenString = object as? String? {
      let keychain = Keychain()
      keychain[key.rawValue] = tokenString
    } else {
      let userDefaults = UserDefaults.standard
      userDefaults.set(object, forKey: key.rawValue)
    }
  }

  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    if key == .apiToken {
      let keychain = Keychain()
      let object = keychain[key.rawValue]
      return object as? T
    } else {
      let userDefaults = UserDefaults.standard
      let object = userDefaults.object(forKey: key.rawValue)
      return object as? T
    }
  }
}
