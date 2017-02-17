//
//  UIImage+Base64.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 21/05/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

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
