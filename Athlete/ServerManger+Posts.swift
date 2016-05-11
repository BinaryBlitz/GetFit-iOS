//
//  ServerManger+Posts.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 11/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

//MARK: - Posts

extension ServerManager {
  
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
  
  func likePostWithId(postId: Int,
                     completion: ((response: ServerResponse<Bool, ServerError>) -> Void)? = nil) -> Request? {
    typealias Response = ServerResponse<Bool, ServerError>
    
    do {
      let request = try post(ServerRoute.Posts.pathWith(String(postId)) + "/\(ServerRoute.Likes.rawValue)")
      request.validate().responseJSON { (response) in
        switch response.result {
        case .Success(let responseValue):
          let json = JSON(responseValue)
          print(json)
          let realm = try! Realm()
          if let likeId = json["id"].int,
              post = realm.objectForPrimaryKey(Post.self, key: postId) {
            try! realm.write {
              post.likeId = likeId
            }
            completion?(response: Response(value: true))
          } else {
            completion?(response: Response(value: false))
          }
        case .Failure(let error):
          completion?(response: Response(error: ServerError(error: error)))
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