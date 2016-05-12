//
//  ServerManager+Trainers.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 11/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

//MARK: - Trainers

extension ServerManager {
  
    func fetchTrainersForCategory(category: TrainerCategory, completion: ((response: ServerResponse<[Trainer], ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<[Trainer], ServerError>
    
    do {
      let parameters = ["category": category.rawValue]
      let request = try get(ServerRoute.Trainers.path, params: parameters)
      activityIndicatorVisible = true
      request.responseJSON { response in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          let trainers = json.flatMap { (_, trainerJSON) -> Trainer? in
            return Trainer(json: trainerJSON)
          }
          
          let realm = try! Realm()
          try! realm.write {
            realm.add(trainers, update: true)
          }
          
          completion?(response: Response(value: trainers))
        case .Failure(let error):
          print(error)
          let response = Response(error: ServerError(error: error))
          completion?(response: response)
        }
      }
      
      return request
    } catch {
      let response = Response(error: .Unauthorized)
      completion?(response: response)
    }
    
    return nil
  }
}