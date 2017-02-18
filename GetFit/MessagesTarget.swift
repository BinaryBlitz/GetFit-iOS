import Foundation
import Moya

extension GetFit {

  public enum Subscriptions {
    case list
    case listMessages(subscriptionId: Int)
    case createMessage(subscriptionId: Int, message: Message)
  }
}

extension GetFit.Subscriptions : TargetType {

  public var path: String {
    switch self {
    case .list:
      return "/subscriptions"
    case .listMessages(let subscriptionId):
      return "/subscriptions/\(subscriptionId)/messages"
    case .createMessage(let subscriptionId, _):
      return "/subscriptions/\(subscriptionId)/messages"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .list, .listMessages(_):
      return .get
    case .createMessage(_, _):
      return .post
    }
  }

  public var parameterEncoding: ParameterEncoding {
    switch self {
    case .list, .listMessages(_):
      return URLEncoding.default
    case .createMessage(_, _):
      return JSONEncoding.default
    }
  }

  public var parameters: [String: Any]? {
    switch self {
    case .list, .listMessages(_):
      return nil
    case .createMessage(_, let message):
      let message: [String: Any] = ["content": message.content! as Any]
      return ["message": message as Any]
    }
  }

}
