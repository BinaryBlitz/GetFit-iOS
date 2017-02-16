import Foundation
import Moya
import Moya_SwiftyJSONMapper
import Toucan
import PhoneNumberKit

private var sessionData: LoginSessionData? = nil

extension GetFit {
  
  public enum Login {
    case phone(phone: PhoneNumber)
    case confirmPhoneNumber(code: String)
    case createUser(firstName: String, lastName: String)
    case vk(token: String)
    case facebook(token: String)
  
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
    case .vk(_):
      return "/user/authenticate_vk"
    case .facebook(_):
      return "/user/authenticate_fb"
    case .phone(_):
      return "/verification_tokens"
    case .confirmPhoneNumber(_):
      return "/verification_tokens/\(sessionData!.verificationToken!)"
    case .createUser(_, _):
      return "/user"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .phone(_), .vk(_), .facebook(_), .createUser(_, _):
      return .post
    case .confirmPhoneNumber(_):
      return .patch
    }
  }

  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }

  public var parameters: [String: Any]? {
    
    switch self {
    case .phone(let phone):
      return ["phone_number" : phone.toE164()]
    case .confirmPhoneNumber(let code):
      return ["phone_number": sessionData!.phoneNumber!.toE164(), "code": code]
    case .vk(let token):
      return ["token": token as Any]
    case .facebook(let token):
      return ["token": token as Any]
    case let .createUser(firstName, lastName):
      let userData = [
        "phone_number": sessionData!.phoneNumber!.toE164(),
        "verification_token": sessionData!.verificationToken!,
        "first_name": firstName,
        "last_name": lastName
      ]
      
      return ["user": userData]
    }
  }
  
}
