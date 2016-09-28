import Foundation
import Moya

/// MoyaProvider subclass with ServerEnvironment support
class APIProvider<Target: TargetType>: MoyaProvider<Target> {
  
  init(environment: ServerEnvironment<Target> = .Staging, plugins: [PluginType] = []) {
    var plugins = plugins
    plugins.append(NetworkActivityManager.shared.plugin)
    super.init(endpointClosure: environment.endpointMapping, plugins: plugins)
  }
}

/// Server environment specificaton. Use it to create a MoyaProvider
enum ServerEnvironment<Target: TargetType> {
  case staging
  case production
  
  var baseURL: URL {
    switch self {
    case .staging:
      return URL(string: "https://getfit-staging.herokuapp.com/api")!
    case.production:
      return URL(string: "")! //TODO: Add production base url
    }
  }
  
  /// Custom endpoint closure for MoyaProvider
  func endpointMapping(_ target: Target) -> Endpoint<Target> {
    let url = baseURL.URLByAppendingPathComponent(target.path).absoluteString
    
    return Endpoint<Target>(
      URL: url, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)},
      method: target.method, parameters: parametersWithAPIToken(target.parameters)
    )
  }
  
  /// Creates parametes dictionary with api token
  fileprivate func parametersWithAPIToken(_ parameters: [String: AnyObject]?) -> [String: AnyObject]? {
    var params = parameters ?? [:]
    if let token = UserManager.apiToken {
      params["api_token"] = token as AnyObject?
    }
    
    return params
  }
}

/// Hides unused TargetType capabilities to clean up targets code
extension TargetType {
  public var baseURL: NSURL { return NSURL() }
  public var sampleData: NSData { return NSData() }
}
