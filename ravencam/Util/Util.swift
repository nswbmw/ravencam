//
//  Util.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/20.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class Util {
  // 震动
  static func shake() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
  }
  
  // 日期
  static func getTime() -> String {
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy MM dd"
    let date = Date()
    let dateString = dateFormatter.string(from: date)
    
    return dateString
  }
}
