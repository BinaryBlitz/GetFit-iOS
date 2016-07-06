//
//  Program.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import SwiftyJSON
import Realm
import RealmSwift

class Program: Object, JSONSerializable {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var programPreview: String = ""
  dynamic var programDescription: String = ""
  dynamic var bannerURLPath: String = ""
  dynamic var trainer: Trainer?
  dynamic var type: String = ""
  dynamic var price: Int = 0
  dynamic var duration: Int = 0
  dynamic var workoutsCount: Int = 0
  dynamic var usersCount: Int = 0
  dynamic var rating: Double = 0
  
  dynamic var bannerURLString: String {
    return ServerManager.sharedManager.pathToImage(bannerURLPath)
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init() {
    super.init()
  }
  
  required init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    guard let id = json["id"].int, name = json["name"].string, preview = json["preview"].string,
          price = json["price"].int, programDescription = json["description"].string else {
      return nil
    }
    
    self.id = id
    self.name = name
    self.programPreview = preview
    self.programDescription = programDescription
    self.price = price
    
    if let bannerURLPath = json["banner_url"].string {
      self.bannerURLPath = bannerURLPath
    }
    
    if let duration = json["duration"].int {
      self.duration = duration
    }
    
    if let type = json["program_type"]["name"].string {
      self.type = type
    }
    
    if let trainer = Trainer(json: json["trainer"]) {
      self.trainer = trainer
      let realm = try! Realm()
      try! realm.write {
        realm.add(trainer, update: true)
      }
    }
   
    if let workoutsCount = json["workouts_count"].int {
      self.workoutsCount = workoutsCount
    }
    
    if let usersCount = json["users_count"].int {
      self.usersCount = usersCount
    }
    
    if let rating = json["rating"].double {
      self.rating = rating
    }
    
    let workouts = json["workouts"].flatMap { (_, workoutJSON) -> Workout? in
      let workout = Workout(json: workoutJSON)
      workout?.programId = self.id
      return workout
    }
    
    let realm = try! Realm()
    try! realm.write {
      realm.delete(realm.objects(Workout).filter("programId == \(self.id)"))
      realm.add(workouts, update: true)
    }
  }
  
  required init(value: AnyObject, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }
}