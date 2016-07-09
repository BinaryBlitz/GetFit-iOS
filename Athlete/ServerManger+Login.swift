//
//  ServerManger+Login.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 11/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PhoneNumberKit

//MARK: - Login

extension ServerManager {
  
  /// Creates verirfication token for login with phone number
  func createVerificationTokenFor(phoneNumber: PhoneNumber,
        completion: ((response: ServerResponse<String, ServerError>) -> Void)? = nil) -> Request {
          
    typealias Response = ServerResponse<String, ServerError>
          
    let parameters = ["phone_number" : phoneNumber.toE164()]
    let path = ServerRoute.VerificationTokens.path
    let req = manager.request(.POST, path, parameters: parameters, encoding: .JSON)
    
    activityIndicatorVisible = true
    req.responseJSON { (response) -> Void in
      self.activityIndicatorVisible = false
      switch response.result {
      case .Success(let value):
        let json = JSON(value)
        guard let token = json["token"].string else {
          let serverResponse = Response(error: .InvalidData)
          completion?(response: serverResponse)
          return
        }
        
        let serverResponse = Response(value: token)
        completion?(response: serverResponse)
      case .Failure(let error):
        completion?(response: Response(error: ServerError(error: error)))
      }
    }
    
    return req
  }
  
  /// Method for phone number verification
  func verifyPhoneNumber(phoneNumber: PhoneNumber, withCode code: String, andToken token: String,
      completion: ((response: ServerResponse<Bool, ServerError>) -> Void)? = nil) -> Request {
  
    typealias Response = ServerResponse<Bool, ServerError>
    let parameters = ["phone_number": phoneNumber.toE164(), "code": code]
    let path = ServerRoute.VerificationTokens.pathWith(token)
    let req = manager.request(.PATCH, path, parameters: parameters, encoding: .JSON)
        
    activityIndicatorVisible = true
    req.validate().responseJSON { response in
      self.activityIndicatorVisible = false
      
      switch response.result {
      case .Success(let resultValue):
        let json = JSON(resultValue)
        
        if let apiToken = json["api_token"].string {
          self.apiToken = apiToken
          LocalStorageHelper.save(apiToken, forKey: .ApiToken)
          completion?(response: Response(value: true))
        } else {
          completion?(response: Response(value: false))
        }
      case .Failure(let error):
        completion?(response: Response(error: ServerError(error: error)))
      }
    }
    
    return req
  }
  
  func createNewUserWithData(userData: PhoneSighUpSessionData,
      completion: ((response: ServerResponse<User, ServerError>) -> Void)? = nil) -> Request {
        
    typealias Response = ServerResponse<User, ServerError>
        
    let user: [String: AnyObject] = [
      "phone_number": userData.phoneNumber.toE164(),
      "verification_token": userData.verificationToken,
      "first_name": userData.firstName ?? "",
      "last_name": userData.lastName ?? ""
//        "device_token": ServerManager.sharedInstance.deviceToken ?? NSNull(),
//        "platform": "ios"
    ]
        
    let parameters: [String: AnyObject] = [
      "user": user
    ]
    
    let req = manager.request(.POST, ServerRoute.User.path, parameters: parameters, encoding: .JSON)
    activityIndicatorVisible = true
    req.validate().responseJSON { response in
      self.activityIndicatorVisible = false
      switch response.result {
      case .Success(let resultValue):
        let json = JSON(resultValue)
        
        if let apiToken = json["api_token"].string {
          self.apiToken = apiToken
          LocalStorageHelper.save(apiToken, forKey: .ApiToken)
          completion?(response: Response(value: User()))
        } else {
          completion?(response: Response(error: ServerError.InvalidData))
        }
      case .Failure(let error):
        completion?(response: Response(error: ServerError(error: error)))
      }
    }
    
    return req
  }
    
  func updateDeviceToken(completion: ((response: ServerResponse<Bool, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<Bool, ServerError>
    
    let parameters: [String: AnyObject] = [
      "device_token": ServerManager.sharedManager.deviceToken ?? NSNull(),
      "platform": "ios"
    ]
    
    let user: [String: AnyObject] = ["user": parameters]
    
    do {
      let request = try patch(ServerRoute.User.path, params: user)
      request.validate().responseJSON { (response) in
        switch response.result {
        case .Success(_):
          completion?(response: Response(value: true))
        case .Failure(let error):
          completion?(response: Response(error: ServerError(error: error)))
        }
      }
      
      return request
    } catch {
      completion?(response: Response(error: .Unauthorized))
      return nil
    }
  }
  
  /// Login with Facebook
  func loginWithFacebookToken(token: String,
                     completion: ((response: ServerResponse<User, ServerError>) -> Void)? = nil) -> Request {
    typealias Response = ServerResponse<User, ServerError>
    
    let parameters = ["token": token]
    let request = manager.request(.POST, ServerRoute.FBAuth.path, parameters: parameters, encoding: .URL)
    request.validate().responseJSON { (response) in
      switch response.result {
      case .Success(let resultValue):
        let json = JSON(resultValue)
        print(json)
        if let apiToken = json["api_token"].string {
          self.apiToken = apiToken
          LocalStorageHelper.save(apiToken, forKey: .ApiToken)
          if let user = User(jsonData: json) {
            completion?(response: Response(value: user))
            return
          }
        }
        
        completion?(response: Response(error: .InvalidData))
      case .Failure(let error):
        completion?(response: Response(error: ServerError(error: error)))
      }
    }
    
    return request
  }

  /// Login with VK
  func loginWithVKToken(token: String,
                     completion: ((response: ServerResponse<User, ServerError>) -> Void)? = nil) -> Request {
    typealias Response = ServerResponse<User, ServerError>
    
    let parameters = ["token": token]
    let request = manager.request(.POST, ServerRoute.VKAuth.path, parameters: parameters, encoding: .URL)
    request.validate().responseJSON { (response) in
      switch response.result {
      case .Success(let resultValue):
        let json = JSON(resultValue)
        print(json)
        if let apiToken = json["api_token"].string {
          self.apiToken = apiToken
          LocalStorageHelper.save(apiToken, forKey: .ApiToken)
          if let user = User(jsonData: json) {
            completion?(response: Response(value: user))
            return
          }
        }
        
        completion?(response: Response(error: .InvalidData))
      case .Failure(let error):
        completion?(response: Response(error: ServerError(error: error)))
      }
    }
    
    return request
  }
}