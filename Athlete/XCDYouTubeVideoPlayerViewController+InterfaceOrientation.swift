import XCDYouTubeKit

extension XCDYouTubeVideoPlayerViewController {
  
  public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return .Landscape
  }
  
  public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
    return .LandscapeLeft
  }
}
