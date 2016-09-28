//
//  LocalStorageHelper.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

struct LocalStorageHelper {
  
  enum StorageKey: String {
    //TODO: save api token to the keychain
    case apiToken
    case deviceToken
    case shouldUpdateDeviceToken
  }
  
  static func save(_ object: Any?, forKey key: StorageKey) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(object, forKey: key.rawValue)
  }
  
  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    let userDefaults = UserDefaults.standard
    let object = userDefaults.object(forKey: key.rawValue)
    return object as? T
  }
}
