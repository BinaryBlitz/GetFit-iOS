import Foundation
import Moya

extension GetFit {
  
  public enum Subscriptions {
    case List
    case ListMessages(subscriptionId: Int)
    case CreateMessage(subscriptionId: Int, message: Message)
  }
}

extension GetFit.Subscriptions : TargetType {
  
  public var path: String {
    switch self {
    case .List:
      return "/subscriptions"
    case .ListMessages(let subscriptionId):
      return "/subscriptions/\(subscriptionId)/messages"
    case .CreateMessage(let subscriptionId, _):
      return "/subscriptions/\(subscriptionId)/messages"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .List, .ListMessages(_):
      return .GET
    case .CreateMessage(_, _):
      return .POST
    }
  }
  
  public var parameters: [String: AnyObject]? {
    switch self {
    case .List, .ListMessages(_):
      return nil
    case .CreateMessage(_, let message):
      let message: [String: AnyObject] = ["content": message.content!]
      return ["message": message]
    }
  }
  
}
