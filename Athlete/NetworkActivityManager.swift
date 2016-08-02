import Moya

class NetworkActivityManager {
  
  static let shared = NetworkActivityManager()
  
  private var numberOfProcesses: Int = 0
  
  func networkActivityChanged(change: Moya.NetworkActivityChangeType) {
    switch change {
    case .Began:
      numberOfProcesses += 1
    case .Ended:
      numberOfProcesses -= 1
      if numberOfProcesses < 0 {
        numberOfProcesses = 0
      }
    }
    
    UIApplication.sharedApplication().networkActivityIndicatorVisible = numberOfProcesses > 0
  }
  
  var plugin: PluginType {
    return NetworkActivityPlugin(networkActivityClosure: networkActivityChanged(_:))
  }
}
