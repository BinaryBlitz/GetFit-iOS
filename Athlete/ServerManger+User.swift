//
//  ServerManger+User.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 11/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Toucan

//MARK: - User

extension ServerManager {
  
  func loadCurrentUser(completion: ((response: ServerResponse<User, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<User, ServerError>
    
    do {
      let request = try get(ServerRoute.User.path)
      request.validate().responseJSON { (response) in
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          if let user = User(json: json) {
            completion?(response: Response(value: user))
          } else {
          completion?(response: Response(error: .InvalidData))
          }
        case .Failure(let error):
          let serverError = ServerError(error: error)
          completion?(response: Response(error: serverError))
        }
      }
      
      return request
    } catch {
      completion?(response: Response(error: .Unauthorized))
      return nil
    }
  }
  
  func updateStatisticsFor(user: User, completion: ((response: ServerResponse<User, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<User, ServerError>
    
    do {
      let request = try get("\(ServerRoute.Users.pathWith(user.id))/\(ServerRoute.Statistics.rawValue)")
      request.validate().responseJSON { (response) in
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          
          if let totalWorkouts = json["workouts_count"].int {
            user.totalWorkouts = totalWorkouts
          }
          
          if let totalDuration = json["total_duration"].int {
            user.totalDuration = totalDuration
          }
          
          if let totalDistance = json["total_distance"].int {
            user.totalDistance = totalDistance
          }
          
          completion?(response: Response(value: user))
        case .Failure(let error):
          print(error)
          let serverError = ServerError(error: error)
          completion?(response: Response(error: serverError))
        }
      }
      
      return request
    } catch {
      completion?(response: Response(error: .Unauthorized))
      return nil
    }
  }
  
  func updateUser(firstName: String, lastName: String, completion: ((response: ServerResponse<Bool, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<Bool, ServerError>
    
    do {
      let parameters: [String: AnyObject] = ["user": ["first_name": firstName, "last_name": lastName]]
      let request = try patch(ServerRoute.User.path, params: parameters)
      activityIndicatorVisible = true
      request.validate().responseData { (response) in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(_):
          completion?(response: Response(value: true))
        case .Failure(let error):
          print(error)
          let serverError = ServerError(error: error)
          completion?(response: Response(error: serverError))
        }
      }
      
      return request
    } catch {
      completion?(response: Response(error: .Unauthorized))
      return nil
    }
  }
  
  func update(imageType: Image, withImage image: UIImage,  completion: ((response: ServerResponse<Bool, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<Bool, ServerError>
    
    do {
      let image = Toucan(image: image).resizeByCropping(imageType.imageSize).image
      let imageKey = imageType.rawValue.lowercaseString
      let imageData = [imageKey: (image.base64String ?? NSNull())]
      let parameters: [String: AnyObject] = ["user": imageData]
      let request = try patch(ServerRoute.User.path, params: parameters)
      activityIndicatorVisible = true
      request.validate().responseData { (response) in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let responseValue):
          completion?(response: Response(value: true))
        case .Failure(let error):
          print(error)
          let serverError = ServerError(error: error)
          completion?(response: Response(error: serverError))
        }
      }
      
      return request
    } catch {
      completion?(response: Response(error: .Unauthorized))
      return nil
    }
  }
}