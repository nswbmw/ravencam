//
//  Photo.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/5/19.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import Foundation

class Photo: Codable {
  var deviceId: String?
  var platform: String?
  var model: String?
  var url: String?
  var width: Int?
  var height: Int?
  var flash: String?
  var flip: String?
  var exposure: Float?
  var contrast: Float?
  var sharpen: Float?
  var vignette: Float?
  var noise: Float?
  var blur: Float?
  
  convenience init?(JSON: [String: Any]) {
    self.init()
    deviceId = JSON["deviceId"] as? String
    platform = JSON["platform"] as? String
    model = JSON["model"] as? String
    url = JSON["url"] as? String
    width = JSON["width"] as? Int
    height = JSON["height"] as? Int
    flash = JSON["flash"] as? String
    flip = JSON["flip"] as? String
    exposure = (JSON["exposure"] as? NSNumber)?.floatValue
    contrast = (JSON["contrast"] as? NSNumber)?.floatValue
    sharpen = (JSON["sharpen"] as? NSNumber)?.floatValue
    vignette = (JSON["vignette"] as? NSNumber)?.floatValue
    noise = (JSON["noise"] as? NSNumber)?.floatValue
    blur = (JSON["blur"] as? NSNumber)?.floatValue
  }
}
