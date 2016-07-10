import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {
  
  public enum Users {
    case GetCurrent
    case Update(firstName: String, lastName: String)
    case UpdateImage(type: Image, image: UIImage)
    case GetStatistics(forUserWithId: Int)
  }
  
}

extension GetFit.Users: TargetType {
  
  public var path: String {
    switch self {
    case .GetCurrent, .UpdateImage(_, _), .Update(_, _):
      return "/user"
    case .GetStatistics(let id):
      return "/users/\(id)/statistics"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .GetCurrent, .GetStatistics(_):
      return .GET
    case .Update(_, _), .UpdateImage(_, _):
      return .PATCH
    }
  }
  
  public var parameters: [String: AnyObject]? {
    var parameters = [String: AnyObject]()
    
    switch self {
    case .GetCurrent, .GetStatistics(_):
      break
    case let .Update(firstName, lastName):
      parameters = ["user": ["first_name": firstName, "last_name": lastName]]
    case let .UpdateImage(type, image):
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
}
