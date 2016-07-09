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
}