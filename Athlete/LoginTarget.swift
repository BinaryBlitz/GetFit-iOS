import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan
import PhoneNumberKit

private var sessionData: LoginSessionData? = nil

extension GetFit {
  
  public enum Login {
    case Phone(phone: PhoneNumber)
    case ConfirmPhoneNumber(code: String)
    case CreateUser(firstName: String, lastName: String)
    case VK(token: String)
    case Facebook(token: String)
  
    static var currentSessionData: LoginSessionData? {
      get {
        return sessionData
      }
      set {
        sessionData = newValue
      }
    }
  }
  
}

extension GetFit.Login: TargetType {
  
  public var path: String {
    switch self {
    case .VK(_):
      return "/user/authenticate_vk"
    case .Facebook(_):
      return "/user/authenticate_fb"
    case .Phone(_):
      return "/verification_tokens"
    case .ConfirmPhoneNumber(_):
      return "/verification_tokens/\(sessionData!.verificationToken)"
    case .CreateUser(_, _):
      return "/user"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .Phone(_), .VK(_), .Facebook(_), .CreateUser(_, _):
      return .POST
    case .ConfirmPhoneNumber(_):
      return .PATCH
    }
  }
  
  public var parameters: [String: AnyObject]? {
    
    switch self {
    case .Phone(let phone):
      return ["phone_number" : phone.toE164()]
    case .ConfirmPhoneNumber(let code):
      return ["phone_number": sessionData!.phoneNumber!.toE164(), "code": code]
    case .VK(let token):
      return ["token": token]
    case .Facebook(let token):
      return ["token": token]
    case let .CreateUser(firstName, lastName):
      return [
        "phone_number": sessionData!.phoneNumber!.toE164(),
        "verification_token": sessionData!.verificationToken!,
        "first_name": firstName,
        "last_name": lastName
//        "device_token": ServerManager.sharedInstance.deviceToken ?? NSNull(),
//        "platform": "ios"
      ]
    }
  }
  
}