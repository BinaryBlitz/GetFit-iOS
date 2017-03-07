//
//  EmptyTablePlaceholderView.swift
//  GetFit
//
//  Created by Алексей on 01.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import Reusable

class EmptyTablePlaceholderView: UITableViewHeaderFooterView, NibReusable {
  @IBOutlet weak var noItemsLabel: UILabel!

  static var reuseIdentifier: String = "EmptyTablePlaceholderView"

  var nib: UINib {
    return UINib(nibName: "EmptyTablePlaceholderView", bundle: nil)
  }

  static func nibInstance() -> EmptyTablePlaceholderView {
    return nib.instantiate(withOwner: nil, options: nil)[0] as! EmptyTablePlaceholderView
  }
}
