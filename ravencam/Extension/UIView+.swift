//
//  UIImage+.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/26.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

extension UIView {
  func setWidth(_ width: CGFloat) {
    self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: self.frame.height)
  }
  
  func setHeight(_ height: CGFloat) {
    self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: height)
  }
  
  //将当前视图转为UIImage
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}
