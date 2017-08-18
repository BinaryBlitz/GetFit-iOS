import Foundation
import Moya

/// MoyaProvider subclass with ServerEnvironment support

class APIProvider<Target:TargetType>: MoyaProvider<Target> {

  init(environment: ServerEnvironment<Target> = .staging, plugins: [PluginType] = []) {
    var plugins = plugins
    plugins.append(NetworkActivityManager.shared.plugin)
    super.init(endpointClosure: environment.endpointMapping, plugins: plugins)
  }
}

/// Server environment specificaton. Use it to create a MoyaProvider

enum ServerEnvironment<Target:TargetType> {
  case staging
  case production

  var baseURL: URL {
    switch self {
    case .staging:
      return URL(string: "https://getfit-staging.herokuapp.com/api")!
    case .production:
      return URL(string: "https://getfit-production.herokuapp.com/api")!
    }
  }

  /// Custom endpoint closure for MoyaProvider
  func endpointMapping(_ target: Target) -> Endpoint<Target> {
    let url = baseURL.appendingPathComponent(target.path).absoluteString

    return Endpoint<Target>(
      url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) },
      method: target.method, parameters: parametersWithAPIToken(target.parameters)
    )
  }

  /// Creates parametes dictionary with api token
  fileprivate func parametersWithAPIToken(_ parameters: [String: Any]?) -> [String: Any]? {
    var params = parameters ?? [:]
    if let token = UserManager.apiToken {
      params["api_token"] = token as Any?
    }

    return params
  }
}

/// Hides unused TargetType capabilities to clean up targets code

extension TargetType {
  public var baseURL: URL { return URL(string: "")! }
  public var sampleData: Data { return Data() }
  public var multipartBody: [MultipartFormData]? { return nil }
  public var task: Task { return .request }
}
