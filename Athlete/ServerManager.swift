//
//  ServerManager.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Alamofire
import SwiftyJSON
import PhoneNumberKit

class ServerManager {
  
  static let sharedManager = ServerManager()
  
  private var manager = Manager.sharedInstance
  let baseURL = "http://getfit.binaryblitz.ru/"
  
  //MARK: - Tokens
  
#if DEBUG
  var apiToken: String? {
    didSet {
      print("Api token updated: \(apiToken ?? "")")
    }
  }
  
  var deviceToken: String? {
    didSet {
      print("Device token updated: \(deviceToken ?? "")")
    }
  }
#else
  var apiToken: String?
  var deviceToken: String?
#endif
  
  //MARK: - Preperties
  
  var authenticated: Bool {
    return apiToken != nil
  }
  
  //MARK: - Basic private methods
  
  private func request(method: Alamofire.Method, path: String,
    parameters: [String : AnyObject]?,
    encoding: ParameterEncoding) throws -> Request {
      let url = baseURL + path
      var parameters = parameters
      guard let token = apiToken else {
        throw ServerError.Unauthorized
      }
      
      if parameters != nil {
        parameters!["api_token"] = token
      } else {
        parameters = ["api_token": token]
      }
      
      return manager.request(method, url, parameters: parameters, encoding: encoding)
  }
  
  /// GET request with api token
  private func get(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.GET, path: path, parameters: params, encoding: .URL)
  }
  
  /// POST request with api token
  private func post(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.POST, path: path, parameters: params, encoding: .JSON)
  }
  
  /// PATCH request with api token
  private func patch(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.PATCH, path: path, parameters: params, encoding: .JSON)
  }
  
  private var activityIndicatorVisible: Bool = false {
    didSet {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = activityIndicatorVisible
    }
  }
  
  //MARK: - Login
  
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
          let serverResponse = Response(value: nil, error: .InvalidData)
          completion?(response: serverResponse)
          return
        }
        
        let serverResponse = Response(value: token, error: nil)
        completion?(response: serverResponse)
      case .Failure(let error):
        completion?(response: Response(value: nil, error: ServerError(error: error)))
      }
    }
    
    return req
  }
  
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
        
        // if api_token nil then create new user
        if let apiToken = json["api_token"].string {
          self.apiToken = apiToken
          completion?(response: Response(value: true, error: nil))
        } else {
          completion?(response: Response(value: false, error: nil))
        }
      case .Failure(let error):
        completion?(response: Response(value: nil, error: ServerError(error: error)))
      }
    }
    
    return req
  }
  
//  func createNewUserWith(phoneNumber: String, andVerificationToken token: String, completion: ((error: ErrorType?) -> Void)?) -> Request {
//    
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//    let parameters: [String: AnyObject] = [
//      "user": [
//        "phone_number": phoneNumber,
//        "verification_token": token,
//        "device_token": ServerManager.sharedInstance.deviceToken ?? NSNull(),
//        "platform": "ios"
//      ]
//    ]
//    
//    let req = manager.request(.POST, baseURL + "user", parameters: parameters, encoding: .JSON)
//    req.validate().responseJSON { (response) -> Void in
//      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//      switch response.result {
//      case .Success(let resultValue):
//        let json = JSON(resultValue)
//        
//        if let apiToken = json["api_token"].string {
//          self.apiToken = apiToken
//          completion?(error: nil)
//        } else {
//          completion?(error: ServerError.InvalidData)
//        }
//      case .Failure(let error):
//        completion?(error: error)
//      }
//    }
//    
//    return req
//  }
}