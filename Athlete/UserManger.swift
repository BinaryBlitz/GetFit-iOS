// Struct for managing logged in user data
struct UserManager {
  static var currentUser: User?
  
  static var apiToken: String? {
    didSet {
      LocalStorageHelper.save(apiToken, forKey: .ApiToken)
    }
  }
  
  static var deviceToken: String? {
    didSet {
      LocalStorageHelper.save(deviceToken, forKey: .DeviceToken)
    }
  }
}