import PhoneNumberKit

public struct LoginSessionData {

  var phoneNumber: PhoneNumber?
  var verificationToken: String?

  init(phoneNumber: PhoneNumber) {
    self.phoneNumber = phoneNumber
  }

  init(phoneNumber: PhoneNumber, verificationToken: String) {
    self.phoneNumber = phoneNumber
    self.verificationToken = verificationToken
  }
}
