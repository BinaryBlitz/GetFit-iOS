import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan

extension GetFit {
  
  public enum Users {
    case getCurrent
    case update(firstName: String, lastName: String)
    case updateImage(type: Image, image: UIImage)
    case getStatistics(forUserWithId: Int)
    case updateDeviceToken(token: String)
  }
  
}

extension GetFit.Users: TargetType {
  
  public var path: String {
    switch self {
    case .getCurrent, .UpdateImage(_, _), .update(_, _):
      return "/user"
    case .getStatistics(let id):
      return "/users/\(id)/statistics"
    case .updateDeviceToken(_):
      return "/user"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .getCurrent, .getStatistics(_):
      return .GET
    case .update(_, _), .UpdateImage(_, _), .updateDeviceToken(_):
      return .PATCH
    }
  }
  
  public var parameters: [String: Any]? {
    
    switch self {
    case .getCurrent, .getStatistics(_):
      return nil
    case let .update(firstName, lastName):
      return ["user": ["first_name": firstName, "last_name": lastName]]
    case let .UpdateImage(type, image):
      let image = Toucan(image: image).resizeByCropping(type.imageSize).image
      let imageKey = type.rawValue.lowercaseString
      return ["user": [imageKey: (image.base64String ?? NSNull())]]
    case .updateDeviceToken(let token):
      return ["user": ["device_token": token, "platform": "ios"]]
    }
  }
}
