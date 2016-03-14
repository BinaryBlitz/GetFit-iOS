//
//  ServerRoute.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

enum ServerRoute {
  case VerificationTokens
  case User
  
  var path: String {
    let baseURL = ServerManager.sharedManager.baseURL
    switch self {
    case .VerificationTokens:
      return baseURL + "verification_tokens"
    case .User:
      return baseURL + "user"
    }
  }
  
  func pathWith<Value: CustomStringConvertible>(value: Value) -> String {
    return self.path + "/\(value)"
  }
  
  func pathWith(value: String) -> String {
    return self.path + "/\(value)"
  }
}