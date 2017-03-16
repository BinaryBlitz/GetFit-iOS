//
//  SurveyFormData.swift
//  GetFit
//
//  Created by Алексей on 16.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import SwiftyJSON
import Moya_SwiftyJSONMapper

enum Gender: String {
  case male
  case female

  var localizedDesctiption: String {
    switch self {
    case .male:
      return "Мужской"
    case .female:
      return "Женский"
    }
  }
}

enum TrainingLevel: String {
  case begginer
  case fitty
  case athletic

  var localizedDesctiption: String {
    switch self {
    case .begginer:
      return "Начинающий"
    case .fitty:
      return "Спортивный"
    case .athletic:
      return "Атлет"
    }
  }
}

enum TrainingGoal: String {
  case weightLoss
  case weightGain
  case rapidWeightLoss
  case bodyStretching
  case enduranceTraining
  case strengthTraining
  case complexTraining
  case other

  var localizedDesctiption: String {
    switch self {
    case .weightLoss:
      return "Снижение веса"
    case .weightGain:
      return "Набор массы"
    case .rapidWeightLoss:
      return "Сушка"
    case .bodyStretching:
      return "Растяжка"
    case .enduranceTraining:
      return "Развитие выносливости"
    case .strengthTraining:
      return "Развитие силы"
    case .complexTraining:
      return "Комплексные тренировки"
    case .other:
      return "Другое"
    }
  }
}

enum SportsInventory: String {
  case gym
  case workout
  case home

  var localizedDesctiption: String {
    switch self {
    case .gym:
      return "Спортзал"
    case .workout:
      return "Work-out площадка"
    case .home:
      return "Могу заниматься дома"
    }
  }
}

open class SurveyFormData: Object, ALSwiftyJSONAble {

  dynamic var id: Int = UUID().hashValue
  dynamic var age: Int = 0
  dynamic var weight: Int = 0
  dynamic var trainingDaysCount: Int = 0
  dynamic var homeInventory: String = ""
  dynamic private var genderRaw: String = Gender.male.rawValue
  dynamic private var trainingLevelRaw: String = TrainingLevel.begginer.rawValue
  dynamic private var trainingGoalRaw: String = TrainingGoal.weightLoss.rawValue
  dynamic private var inventoryRaw: String = SportsInventory.gym.rawValue

  var gender: Gender {
    get { return Gender(rawValue: genderRaw) ?? .male }
    set { genderRaw = newValue.rawValue }
  }

  var trainingLevel: TrainingLevel {
    get { return TrainingLevel(rawValue: trainingLevelRaw) ?? .begginer }
    set { trainingLevelRaw = newValue.rawValue }
  }

  var trainingGoal: TrainingGoal {
    get { return TrainingGoal(rawValue: trainingGoalRaw) ?? .weightLoss }
    set { trainingGoalRaw = newValue.rawValue }
  }

  var inventory: SportsInventory {
    get { return SportsInventory(rawValue: inventoryRaw) ?? .gym }
    set { inventoryRaw = newValue.rawValue }
  }

  override open static func primaryKey() -> String? {
    return "id"
  }

  required public init() {
    super.init()
  }

  required public init?(jsonData: JSON) {
    super.init()

    if let id  = jsonData["id"].int {
      self.id = id
    }

    if let genderString = jsonData["gender"].string {
      self.genderRaw = genderString
    }

    if let trainingLevelString = jsonData["training_level"].string {
      self.trainingLevelRaw = trainingLevelString
    }

    if let trainingGoalString = jsonData["training_goal"].string {
      self.trainingGoalRaw = trainingGoalString
    }

    if let inventoryString = jsonData["inventory"].string {
      self.inventoryRaw = inventoryString
    }

    if let age = jsonData["age"].int {
      self.age = age
    }

    if let weight = jsonData["weight"].int {
      self.weight = weight
    }

    if let trainingDaysCount = jsonData["training_days"].int {
      self.trainingDaysCount = trainingDaysCount
    }

    if let homeInventory = jsonData["home_inventory"].string {
      self.homeInventory = homeInventory
    }
  }

  // TODO: Map to JSON

  required public init(value: Any, schema: RLMSchema) {
    super.init(value: value, schema: schema)
  }

  required public init(realm: RLMRealm, schema: RLMObjectSchema) {
    super.init(realm: realm, schema: schema)
  }
}
