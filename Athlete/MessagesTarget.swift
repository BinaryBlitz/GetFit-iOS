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
      return .GET
    case .createMessage(_, _):
      return .POST
    }
  }
  
  public var parameters: [String: AnyObject]? {
    switch self {
    case .list, .listMessages(_):
      return nil
    case .createMessage(_, let message):
      let message: [String: AnyObject] = ["content": message.content! as AnyObject]
      return ["message": message as AnyObject]
    }
  }
  
}
