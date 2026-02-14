//
//  Cache.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/5/19.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import DefaultsKit

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { Defaults.shared.get(for: Key<T>(key)) ?? defaultValue }
        set { Defaults.shared.set(newValue, for: Key<T>(key)) }
    }
}

class Cache {
  // 默认拍摄设置
  private static let defaultPhoto = Photo(JSON: [
    "flash": "off",
    "flip": "back",
    "exposure": 0,
    "contrast": 0,
    "sharpen": 0,
    "vignette": 0,
    "noise": 0,
    "blur": 0
  ])!
  
  // 保存拍摄设置
  @UserDefault(key: "config", defaultValue: nil)
  private static var configCache: Photo?
  
  static func getConfig() -> Photo {
    return configCache ?? defaultPhoto
  }
  
  static func setConfig(config: Photo) {
    configCache = config
  }
  
  static func clearConfig() {
    Defaults.shared.clear(Key<Photo>("config"))
  }
  
  // 保存图片元信息
  static func getImageInfo(key: String) -> Photo {
    let key = Key<Photo>(key)
    return Defaults.shared.get(for: key) ?? Photo(JSON: [
      "flash": "off",
      "flip": "back",
      "exposure": 0,
      "contrast": 0,
      "sharpen": 0,
      "vignette": 0,
      "noise": 0,
      "blur": 0
    ])!
  }
  
  static func setImageInfo(key: String, info: Photo) {
    let key = Key<Photo>(key)
    Defaults.shared.set(info, for: key)
  }
  
  static func clearImageInfo(key: String) {
    let key = Key<Photo>(key)
    Defaults.shared.clear(key)
  }
  
  // 无损拍摄
  @UserDefault(key: "loseless", defaultValue: false)
  private static var loselessConfig: Bool
  
  static func getLoselessConfig() -> Bool {
    return loselessConfig
  }
  
  static func setLoselessConfig(on: Bool) {
    loselessConfig = on
  }
  
  // 日期水印
  @UserDefault(key: "watermark", defaultValue: false)
  private static var watermarkConfig: Bool
  
  static func getWatermarkConfig() -> Bool {
    return watermarkConfig
  }
  
  static func setWatermarkConfig(on: Bool) {
    watermarkConfig = on
  }
  
  // 地理位置
  @UserDefault(key: "location", defaultValue: false)
  private static var locationConfig: Bool
  
  static func getLocationConfig() -> Bool {
    return locationConfig
  }
  
  static func setLocationConfig(on: Bool) {
    locationConfig = on
  }
  
}
