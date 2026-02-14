//
//  Float+.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/28.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import Foundation

extension Float {
  func toFixed(_ length: Int) -> Float {
    let divisor = pow(10.0, Float(length))
    return Darwin.round(self * divisor) / divisor
  }
}
