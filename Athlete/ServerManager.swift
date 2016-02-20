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
  
  private var manager = Manager.sharedInstance
  let baseURL = "http://athleteapp.co/"
  
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
  
  private func get(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.GET, path: path, parameters: params, encoding: .URL)
  }
  
  private func post(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.POST, path: path, parameters: params, encoding: .JSON)
  }
  
  private func patch(path: String, params: [String: AnyObject]? = nil) throws -> Request {
    return try request(.PATCH, path: path, parameters: params, encoding: .JSON)
  }
  


}