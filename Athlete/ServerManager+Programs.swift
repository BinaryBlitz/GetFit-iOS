//
//  ServerManager+Programs.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 12/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension ServerManager {
  
  func fetchPrograms(completion: ((response: ServerResponse<[Program], ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<[Program], ServerError>
    
    do {
      let parameters = ["order": "created_at"]
      let request = try get(ServerRoute.Programs.path, params: parameters)
      activityIndicatorVisible = true
      request.responseJSON { response in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          let programs = json.flatMap { (_, programJSON) -> Program? in
            return Program(json: programJSON)
          }
          
          completion?(response: Response(value: programs))
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
    
  func showProgramWithId(programId: Int, completion: ((response: ServerResponse<Program, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<Program, ServerError>
    
    do {
      let request = try get(ServerRoute.Programs.pathWith(programId))
      activityIndicatorVisible = true
      request.responseJSON { response in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          if let program = Program(json: json) {
            completion?(response: Response(value: program))
          } else {
            completion?(response: Response(error: .InvalidData))
          }
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