//
//  LocalStorageHelper.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

struct LocalStorageHelper {
  
  enum StorageKey: String {
    case ApiToken
    case DeviceToken
  }
  
  static func save(object: AnyObject?, forKey key: StorageKey) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setObject(object, forKey: key.rawValue)
  }
  
  static func loadObjectForKey<T>(key: StorageKey) -> T? {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let object = userDefaults.objectForKey(key.rawValue)
    return object as? T
  }
}