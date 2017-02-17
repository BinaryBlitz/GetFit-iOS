//
//  ButtonStripViewDelegate.swift
//  Athlete
//
//  Created by Dan Shevlyuk on 27/03/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

protocol ButtonStripViewDelegate: class {
  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int)
}

extension ButtonStripViewDelegate {
  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int) { }
}
