import UIKit

extension UIViewController {

  func presentAlertWithTitle(_ title: String, andMessage message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  func presentAlertWithMessage(_ message: String?, _ okButtonHandler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: nil, message: message ?? "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okButtonHandler))
    self.present(alert, animated: true, completion: nil)
  }
}
