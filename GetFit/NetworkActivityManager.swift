import Moya

class NetworkActivityManager {

  static let shared = NetworkActivityManager()

  fileprivate var numberOfProcesses: Int = 0

  func networkActivityChanged(_ change: Moya.NetworkActivityChangeType) {
    switch change {
    case .began:
      numberOfProcesses += 1
    case .ended:
      numberOfProcesses -= 1
      if numberOfProcesses < 0 {
        numberOfProcesses = 0
      }
    }

    UIApplication.shared.isNetworkActivityIndicatorVisible = numberOfProcesses > 0
  }

  var plugin: PluginType {
    return NetworkActivityPlugin(networkActivityClosure: networkActivityChanged(_:))
  }
}
