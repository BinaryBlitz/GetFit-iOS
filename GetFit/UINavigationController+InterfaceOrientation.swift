import UIKit

extension UINavigationController {
  open override var shouldAutorotate: Bool {
    return true
  }

  open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
}
