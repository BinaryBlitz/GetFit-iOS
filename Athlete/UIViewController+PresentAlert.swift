//
//  UIViewController+PresentAlert.swift
//  GetHelp
//
//  Created by Dan Shevlyuk on 07/01/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func presentAlertWithTitle(title: String, andMessage message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func presentAlertWithMessage(message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}
