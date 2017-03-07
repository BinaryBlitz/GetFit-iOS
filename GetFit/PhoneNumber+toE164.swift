import Foundation
import PhoneNumberKit

extension PhoneNumber {
  func toE164() -> String? {
    return PhoneNumberKit().format(self, toType: .e164)
  }
}
