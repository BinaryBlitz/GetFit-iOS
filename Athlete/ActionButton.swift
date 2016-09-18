import UIKit
import PureLayout

/// Button with activity indicator
class ActionButton: UIButton {
  
  private var activityIndicator: UIActivityIndicatorView?
  private var originalTitle: String?
  
  func showActivityIndicator() {
    originalTitle = currentTitle
    userInteractionEnabled = false
    setTitle("", forState: .Normal)
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
    activityIndicator = spinner
    spinner.autoSetDimensionsToSize(CGSize(width: 20, height: 20)) // TODO: remove harcodes values
    addSubview(spinner)
    spinner.autoCenterInSuperview()
    spinner.startAnimating()
  }
  
  func hideActivityIndicator() {
    if let indicator = activityIndicator {
      indicator.stopAnimating()
      indicator.removeFromSuperview()
      activityIndicator = nil
      setTitle(originalTitle, forState: .Normal)
    }
    
    userInteractionEnabled = true
  }
  
}
