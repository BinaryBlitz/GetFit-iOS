//
//  EmptyTablePlaceholderView.swift
//  GetFit
//
//  Created by Алексей on 01.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class EmptyTablePlaceholderView: UIView {
  @IBOutlet weak var noItemsLabel: UILabel!

  static func nibInstance() -> EmptyTablePlaceholderView {
    return UINib(nibName: "EmptyTablePlaceholderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyTablePlaceholderView
  }
}
