//
//  Workout.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Realm
import RealmSwift
import SwiftyJSON

class Workout: Object, JSONSerializable {
  
  dynamic var id: Int = 0
  dynamic var name: String = ""
  dynamic var duration: Int = 0
  dynamic var programName: String = ""
  dynamic var programId: Int = 0
  dynamic var position: Int = 0
  dynamic var exercisesCount: Int = 0
  let exercises = List<Exercise>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  required init() {
    super.init()
  }
  
  override init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
  
  required init?(json: JSON) {
    super.init()
    
    guard let id = json["id"].int else {
      return nil
    }
    
    self.id = id
    
    if let name = json["name"].string {
      self.name = name
    } else {
      self.name = "workout name"
    }
    
    if let exercisesCount = json["exercises_count"].int {
      self.exercisesCount = exercisesCount
    }
    
    if let programId = json["program"]["id"].int {
      self.programId = programId
    }
    
    if let programName = json["program"]["name"].string {
      self.programName = programName
    }
    
    if let position = json["position"].int {
      self.position = position
    }
    
    if let duration = json["duration"].int {
      self.duration = duration
    }
    
    let exercises = json["exercises"].flatMap { (_, exerciseJSON) -> Exercise? in
      return Exercise(json: exerciseJSON)
    }
    
    let realm = try! Realm()
    try! realm.write {
      realm.add(exercises)
      self.exercises.removeAll()
      self.exercises.appendContentsOf(exercises)
    }
  }
}