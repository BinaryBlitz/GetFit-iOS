//
//  ServerManager+Workouts.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension ServerManager {
  
  func fetchWorkouts(completion: ((response: ServerResponse<[Workout], ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<[Workout], ServerError>
    
    do {
      let request = try get(ServerRoute.Workouts.path)
      activityIndicatorVisible = true
      request.responseJSON { response in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          print(json)
          let workouts = json.flatMap { (_, workoutJSON) -> Workout? in
            return Workout(jsonData: workoutJSON)
          }
          
          completion?(response: Response(value: workouts))
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