// Struct for managing logged in user data

struct UserManager {
  static var currentUser: User?

  static var apiToken: String? {
    didSet {
      LocalStorageHelper.save(apiToken, forKey: .apiToken)
      print("API Token updated: \(apiToken)")
    }
  }

  static var deviceToken: String? {
    didSet {
      LocalStorageHelper.save(deviceToken, forKey: .deviceToken)
    }
  }

  static var authenticated: Bool {
    return apiToken != nil
  }
}
