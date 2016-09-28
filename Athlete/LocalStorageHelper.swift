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
    case ApiToken
    case DeviceToken
    case ShouldUpdateDeviceToken
  }
  
  static func save(_ object: AnyObject?, forKey key: StorageKey) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(object, forKey: key.rawValue)
  }
  
  static func loadObjectForKey<T>(_ key: StorageKey) -> T? {
    let userDefaults = UserDefaults.standard
    let object = userDefaults.object(forKey: key.rawValue)
    return object as? T
  }
}
