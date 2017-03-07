import UIKit

extension UIImage {

  var base64String: String? {
    let imageData = UIImagePNGRepresentation(self)
    let base64ImageString = imageData?.base64EncodedString(options: .lineLength64Characters)
    if let base64ImageString = base64ImageString {
      let formattedImage = "data:image/gif;base64,\(base64ImageString))"
      return formattedImage
    } else {
      return nil
    }
  }
}
