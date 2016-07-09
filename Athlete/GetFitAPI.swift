//
//  GetFitAPI.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 08/07/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation
import Moya
import Toucan
import Moya_SwiftyJSONMapper
import SwiftyJSON

// MARK: - Provider setup

private func JSONResponseDataFormatter(data: NSData) -> NSData {
    do {
        let dataAsJSON = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        let prettyData =  try NSJSONSerialization.dataWithJSONObject(dataAsJSON, options: .PrettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

//TODO: - add activity indicator manager
let getFitProvider = MoyaProvider<GetFit>(
  plugins: [NetworkLoggerPlugin(responseDataFormatter: JSONResponseDataFormatter)]
)

public enum GetFit {
  
  //MARK: - User
  case GetCurrentUser
  case UpdateUser(firstName: String, lastName: String)
  case UpdateUserImage(type: Image, image: UIImage)
  case GetStatisticsForUser(id: Int)
}

extension GetFit: TargetType {
  
  public var baseURL: NSURL {
    //TODO: Add switch between stagin and production server
    return NSURL(string: "http://getfit-staging.herokuapp.com/api")!
  }
  
  public var path: String {
    switch self {
    case .GetCurrentUser, .UpdateUserImage(_, _), .UpdateUser(_, _):
      return "/user"
    case .GetStatisticsForUser(let id):
      return "/users/\(id)/statistics"
    }
  }
  public var method: Moya.Method {
    switch self {
    case .GetCurrentUser, .GetStatisticsForUser(_):
      return .GET
    case .UpdateUser(_, _), .UpdateUserImage(_, _):
      return .PATCH
    }
  }
  
  public var parameters: [String: AnyObject]? {
    var parameters = [String: AnyObject]()
    
    switch self {
    case .GetCurrentUser, .GetStatisticsForUser(_):
      break
    case let .UpdateUser(firstName, lastName):
      parameters = ["user": ["first_name": firstName, "last_name": lastName]]
    case let .UpdateUserImage(type, image):
      let image = Toucan(image: image).resizeByCropping(type.imageSize).image
      let imageKey = type.rawValue.lowercaseString
      parameters = ["user": [imageKey: (image.base64String ?? NSNull())]]
    }
    
    //TODO: move token to user class
    if let token = ServerManager.sharedManager.apiToken {
      parameters["api_token"] = token
    }
    
    return parameters
  }
  
  public var sampleData: NSData {
    return "u menya net testov ;(".dataUsingEncoding(NSUTF8StringEncoding)!
  }
}