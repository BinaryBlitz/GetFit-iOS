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
import SwiftDate
import RealmSwift

class ServerManager {
  
  static let sharedManager = ServerManager()
  
  private var manager = Manager.sharedInstance
  let baseURL = "http://getfit.binaryblitz.ru"
//  let baseURL = "http://localhost:3000/api/"
  
  var baseAPIURL: String {
    return baseURL + "/api/"
  }
  
  //TODO: - move to servermanager helper or smth 
  
  func pathToImage(imagePath: String) -> String {
    let baseURL = ServerManager.sharedManager.baseURL
    return baseURL + imagePath
  }
  
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
      var parameters = parameters
      guard let token = apiToken else {
        throw ServerError.Unauthorized
      }
      
      if parameters != nil {
        parameters!["api_token"] = token
      } else {
        parameters = ["api_token": token]
      }
      
      return manager.request(method, path, parameters: parameters, encoding: encoding)
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
          if let user = User(json: json) {
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

  
  //MARK: - Posts
  
  func fetchPostsFor(pageIndex: Int,
                     completion: ((response: ServerResponse<Bool, ServerError>) -> Void)? = nil) -> Request? {
    
    typealias Response = ServerResponse<Bool, ServerError>
    let parameters = ["page": pageIndex]
    
    do {
      let request = try get(ServerRoute.Posts.path, params: parameters)
      activityIndicatorVisible = true
      request.responseJSON { response in
        self.activityIndicatorVisible = false
        switch response.result {
        case .Success(let resultValue):
          let json = JSON(resultValue)
          let posts = json.flatMap { (_, postJSON) -> Post? in
            return Post(json: postJSON)
          }
          
          let realm = try! Realm()
          try! realm.write {
            realm.add(posts, update: true)
          }
          
          completion?(response: Response(value: true))
        case .Failure(let error):
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