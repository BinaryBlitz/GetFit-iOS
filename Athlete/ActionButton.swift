import UIKit
import PureLayout

/// Button with activity indicator
class ActionButton: UIButton {
  
  fileprivate var activityIndicator: UIActivityIndicatorView?
  fileprivate var originalTitle: String?
  
  func showActivityIndicator() {
    originalTitle = currentTitle
    isUserInteractionEnabled = false
    setTitle("", for: UIControlState())
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    activityIndicator = spinner
    spinner.autoSetDimensions(to: CGSize(width: 20, height: 20)) // TODO: remove harcodes values
    addSubview(spinner)
    spinner.autoCenterInSuperview()
    spinner.startAnimating()
  }
  
  func hideActivityIndicator() {
    if let indicator = activityIndicator {
      indicator.stopAnimating()
      indicator.removeFromSuperview()
      activityIndicator = nil
      setTitle(originalTitle, for: UIControlState())
    }
    
    isUserInteractionEnabled = true
  }
  
}
