import Foundation

struct UserViewModel {
  let user: User
}

extension UserViewModel: UserPresentable {
  
  var name: String {
    return "\(user.firstName) \(user.lastName)"
  }
  
  var info: String {
    return user.userDescription ?? "No description"
  }
  
  var avatarURL: NSURL? {
    guard let urlString = user.avatarURLString else { return nil }
    return NSURL(string: urlString)
  }
  
  var coverImageURL: NSURL? {
    guard let urlString = user.bannerURLString else { return nil }
    return NSURL(string: urlString)
  }
}

extension UserViewModel: StatisticsPresentable {
  var totalWorkouts: String { return "\(user.totalWorkouts)" }
  var totalDistance: String { return "\(user.totalDistance) km" }
  var totalDuration: String { return "\(user.totalDuration) min" }
  var totalWeight: String { return "\(0) kg" }
}
