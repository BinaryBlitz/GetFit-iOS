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
    case UpdateDeviceToken(token: String)
  }
  
}

extension GetFit.Users: TargetType {
  
  public var path: String {
    switch self {
    case .GetCurrent, .UpdateImage(_, _), .Update(_, _):
      return "/user"
    case .GetStatistics(let id):
      return "/users/\(id)/statistics"
    case .UpdateDeviceToken(_):
      return "/user"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .GetCurrent, .GetStatistics(_):
      return .GET
    case .Update(_, _), .UpdateImage(_, _), .UpdateDeviceToken(_):
      return .PATCH
    }
  }
  
  public var parameters: [String: AnyObject]? {
    
    switch self {
    case .GetCurrent, .GetStatistics(_):
      return nil
    case let .Update(firstName, lastName):
      return ["user": ["first_name": firstName, "last_name": lastName]]
    case let .UpdateImage(type, image):
      let image = Toucan(image: image).resizeByCropping(type.imageSize).image
      let imageKey = type.rawValue.lowercaseString
      return ["user": [imageKey: (image.base64String ?? NSNull())]]
    case .UpdateDeviceToken(let token):
      return ["user": ["device_token": token, "platform": "ios"]]
    }
  }
}
