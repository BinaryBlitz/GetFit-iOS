import Foundation
import UIKit
import PhoneNumberKit

/// GetFit server requests
public struct GetFit {
  
  static var apiToken: String? {
    didSet {
      print("Api token updated: \(apiToken)")
    }
  }
  
  static var authenticated: Bool {
    return apiToken != nil
  }
  
}
