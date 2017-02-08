import UIKit

extension UINavigationController {
  public override func shouldAutorotate() -> Bool {
    return true
  }
  
  public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Portrait
  }
}
