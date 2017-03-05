//
//  YouTubeVideoViewController.swift
//  GetFit
//
//  Created by Алексей on 05.03.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit
import XCDYouTubeKit

class YouTubeVideoViewController: XCDYouTubeVideoPlayerViewController {
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.portrait, .landscape]
  }

  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return .portrait
  }
}
