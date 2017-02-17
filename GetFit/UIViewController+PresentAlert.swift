//
//  UIViewController+PresentAlert.swift
//  GetHelp
//
//  Created by Dan Shevlyuk on 07/01/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func presentAlertWithTitle(_ title: String, andMessage message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func presentAlertWithMessage(_ message: String?) {
    let alert = UIAlertController(title: nil, message: message ?? "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
