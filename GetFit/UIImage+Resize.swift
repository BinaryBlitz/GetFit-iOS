import UIKit

extension UIImage {
  
  /// Load and resize an image using `CGContextDrawImage(...)`.
  static func resizeImage(_ image: UIImage, withScalingFactor scalingFactor: Double) -> UIImage? {
    let cgImage = image.cgImage!
    
    let width = Double(cgImage.width) * scalingFactor
    let height = Double(cgImage.height) * scalingFactor
    let bitsPerComponent = cgImage.bitsPerComponent
    let bytesPerRow = cgImage.bytesPerRow
    let colorSpace = cgImage.colorSpace!
    let bitmapInfo = cgImage.bitmapInfo
    
    guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
      return nil
    }
    
    context.interpolationQuality = .high
    
    context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))
    
    let scaledImage = context.makeImage().flatMap { return UIImage(cgImage: $0) }
    return scaledImage
  }
  
  static func cropToBounds(_ image: UIImage, width: CGFloat, height: CGFloat) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let picture1 = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let imageData = UIImagePNGRepresentation(picture1)
    let img = UIImage(data: imageData!)
    return img
  }
}
