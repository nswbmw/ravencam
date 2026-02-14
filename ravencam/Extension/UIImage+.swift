//
//  UIImage+.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/30.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

extension UIImage {
  // 改变大小
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  // 旋转
  func rotate(radians: Float) -> UIImage? {
      var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
      // Trim off the extremely small float value to prevent core graphics from rounding it up
      newSize.width = floor(newSize.width)
      newSize.height = floor(newSize.height)

      UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
      let context = UIGraphicsGetCurrentContext()!

      // Move origin to middle
      context.translateBy(x: newSize.width/2, y: newSize.height/2)
      // Rotate around middle
      context.rotate(by: CGFloat(radians))
      // Draw the image at its center
      self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return newImage
  }
  
  func alpha(_ alpha: CGFloat) -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      draw(at: .zero, blendMode: .normal, alpha: alpha)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return newImage
  }
  // 读取 EXIF
  func getEXIF() -> NSDictionary {
    let imageData: Data = self.jpegData(compressionQuality: 1)!
    let cgImgSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
    let imageProperties = CGImageSourceCopyPropertiesAtIndex(cgImgSource, 0, nil)! as NSDictionary
    return imageProperties
  }

  // 写入 EXIF
  func writeEXIF(exif: String) -> Data {
    let imageData: Data = self.jpegData(compressionQuality: 1)!
    let cgImgSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, nil)!
    let uti: CFString = CGImageSourceGetType(cgImgSource)!
    let dataWithEXIF: NSMutableData = NSMutableData(data: imageData)
    let destination: CGImageDestination = CGImageDestinationCreateWithData((dataWithEXIF as CFMutableData), uti, 1, nil)!
    
    let imageProperties = CGImageSourceCopyPropertiesAtIndex(cgImgSource, 0, nil)! as NSDictionary
    let mutable: NSMutableDictionary = imageProperties.mutableCopy() as! NSMutableDictionary

    var EXIFDictionary: NSMutableDictionary = (mutable[kCGImagePropertyExifDictionary as String] as? NSMutableDictionary)!

    EXIFDictionary[kCGImagePropertyExifUserComment as String] = exif

    mutable[kCGImagePropertyExifDictionary as String] = EXIFDictionary

    CGImageDestinationAddImageFromSource(destination, cgImgSource, 0, (mutable as CFDictionary))
    CGImageDestinationFinalize(destination)

    return dataWithEXIF as Data
  }
  
  // 添加日期水印
  func addWatermark()  -> UIImage {
    let backgroundImage = self
    let width = backgroundImage.size.width
    let height = backgroundImage.size.height

    let watermarkViewNib = UINib(nibName: "WatermarkView", bundle: Bundle.main)
    let watermarkView = watermarkViewNib.instantiate(withOwner: self, options: nil)[0] as! WatermarkView
    watermarkView.frame = CGRect(x: 0, y: 0, width: watermarkView.bounds.width, height: watermarkView.bounds.width * (height/width))

    let watermarkImage = watermarkView.asImage()

    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
    backgroundImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
    watermarkImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return result!
  }
}
