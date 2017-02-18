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
    case .getCurrent, .updateImage(_, _), .update(_, _):
      return "/user"
    case .getStatistics(let id):
      return "/users/\(id)/statistics"
    case .updateDeviceToken(_):
      return "/user"
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }

  public var method: Moya.Method {
    switch self {
    case .getCurrent, .getStatistics(_):
      return .get
    case .update(_, _), .updateImage(_, _), .updateDeviceToken(_):
      return .get
    }
  }

  public var parameters: [String: Any]? {

    switch self {
    case .getCurrent, .getStatistics(_):
      return nil
    case let .update(firstName, lastName):
      return ["user": ["first_name": firstName, "last_name": lastName]]
    case let .updateImage(type, image):
      let image = Toucan(image: image).resizeByCropping(type.imageSize).image
      let imageKey = type.rawValue.lowercased()
      return ["user": [imageKey: (image.base64String)]]
    case .updateDeviceToken(let token):
      return ["user": ["device_token": token, "platform": "ios"]]
    }
  }
}
