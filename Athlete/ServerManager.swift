//
//  ServerManager.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 20/02/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Alamofire

class ServerManager {
  
  static let sharedManager = ServerManager()
  
  var manager = Manager.sharedInstance
  let baseURL = "http://getfit-staging.herokuapp.com"
  
  var baseAPIURL: String {
    return baseURL + "/api/"
  }
  
  //TODO: - move to servermanager helper or smth 
  
  func pathToImage(imagePath: String) -> String {
    return imagePath
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
  
  //MARK: - Properties
  
  var authenticated: Bool {
    return apiToken != nil
  }
  
  //MARK: - Basic methods
  
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
  func get(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.GET, path: path, parameters: params, encoding: .URL)
  }
  
  /// POST request with api token
  func post(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.POST, path: path, parameters: params, encoding: .JSON)
  }
  
  /// PATCH request with api token
  func patch(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.PATCH, path: path, parameters: params, encoding: .JSON)
  }
  
  var activityIndicatorVisible: Bool = false {
    didSet {
      UIApplication.sharedApplication().networkActivityIndicatorVisible = activityIndicatorVisible
    }
  }
}