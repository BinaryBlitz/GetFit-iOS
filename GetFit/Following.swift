//
//  Following.swift
//  GetFit
//
//  Created by Алексей on 01.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON
import SwiftDate
import Moya_SwiftyJSONMapper

class Following: ALSwiftyJSONAble {
  dynamic var createdAt: Date = Date()
  dynamic var id: Int = 0
  dynamic var trainerId: Int = 0

  required init(jsonData: JSON) {

    guard let id = jsonData["id"].int, let createdAt = jsonData["created_at"].string, let trainerId = jsonData["trainer_id"].int else {
      return
    }
    self.id = id
    self.trainerId = trainerId

    let createdAtDate = try? createdAt.date(format: .iso8601(options: .withInternetDateTimeExtended))
    self.createdAt = createdAtDate?.absoluteDate ?? Date()
  }
}
