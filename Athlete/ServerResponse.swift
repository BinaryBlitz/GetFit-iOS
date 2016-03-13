//
//  ServerResponse.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 13/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Alamofire

struct ServerResponse<Value, Error: ErrorType> {
  
  let value: Value?
  let error: Error?
  
  var result: Result<Value, Error>? {
    if let value = value {
      return Result.Success(value)
    } else if let error = error {
      return Result.Failure(error)
    }
    
    return nil
  }
}