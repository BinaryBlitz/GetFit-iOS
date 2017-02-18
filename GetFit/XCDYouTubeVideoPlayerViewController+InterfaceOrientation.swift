import XCDYouTubeKit

extension XCDYouTubeVideoPlayerViewController {

  open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return .landscape
  }

  open override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
    return .landscapeLeft
  }
}
