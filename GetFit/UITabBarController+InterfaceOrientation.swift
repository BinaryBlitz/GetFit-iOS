import UIKit

extension UITabBarController {
  public override func shouldAutorotate() -> Bool {
    return true
  }
  
  public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.Portrait
  }
}
