import Foundation

protocol ButtonStripViewDelegate: class {
  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int)
}

extension ButtonStripViewDelegate {
  func stripView(_ view: ButtonsStripView, didSelectItemAtIndex index: Int) { }
}
