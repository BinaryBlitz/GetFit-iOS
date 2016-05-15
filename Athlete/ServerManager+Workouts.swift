//
//  ServerManager+Workouts.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 15/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftDate

extension ServerManager {
  
  func fetchWorkoutSessions(completion: ((response: ServerResponse<[WorkoutSession], ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<[WorkoutSession], ServerError>
    
    do {
      let request = try get(ServerRoute.WorkoutSessions.path)
      activityIndicatorVisible = true
      request.responseJSON { response in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          print(json)
          let sessions = json.flatMap { (_, workoutSessionJSON) -> WorkoutSession? in
            return WorkoutSession(json: workoutSessionJSON)
          }
          
          completion?(response: Response(value: sessions))
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