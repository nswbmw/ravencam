//
//  SlideView.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/25.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class SlideView: UIView {

  @IBOutlet weak var downImageView: UIImageView!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var countLabel: UILabel!
  
  // 类型（点击哪个参数弹起来的），如: blur
  var type: String? {
    didSet {
      if type == nil {
        return
      }
      let config = Cache.getConfig()
      switch type {
      case "exposure":
        slider.minimumValue = -10
        slider.maximumValue = 10
        slider.value = config.exposure ?? 0
        countLabel.text = String(format: "%.1f", config.exposure ?? 0)
      case "contrast":
        slider.minimumValue = -10
        slider.maximumValue = 10
        slider.value = config.contrast ?? 0
        countLabel.text = String(format: "%.1f", config.contrast ?? 0)
      case "sharpen":
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = config.sharpen ?? 0
        countLabel.text = String(format: "%.1f", config.sharpen ?? 0)
      case "vignette":
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = config.vignette ?? 0
        countLabel.text = String(format: "%.1f", config.vignette ?? 0)
      case "noise":
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = config.noise ?? 0
        countLabel.text = String(format: "%.1f", config.noise ?? 0)
      case "blur":
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = config.blur ?? 0
        countLabel.text = String(format: "%.1f", config.blur ?? 0)
      default:
        break
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

    slider.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    countLabel.font = UIFont(name: "Gotham-Book", size: 14)
    
    // 双击countLabel，重置
    let doubleTapCountLabel = UITapGestureRecognizer(target: self, action: #selector(reset))
    doubleTapCountLabel.numberOfTapsRequired = 2
    countLabel.addGestureRecognizer(doubleTapCountLabel)
  }
  
  // 重置
  @objc func reset() {
    Util.shake()
    
    if type == nil {
      return
    }
    let config = Cache.getConfig()
    switch type {
    case "exposure":
      slider.value = 0
      countLabel.text = "0.0"
      config.exposure = 0
    case "contrast":
      slider.value =  0
      countLabel.text = "0.0"
      config.contrast = 0
    case "sharpen":
      slider.value = 0
      countLabel.text = "0.0"
      config.sharpen = 0
    case "vignette":
      slider.value = 0
      countLabel.text = "0.0"
      config.vignette = 0
    case "noise":
      slider.value = 0
      countLabel.text = "0.0"
      config.noise = 0
    case "blur":
      slider.value = 0
      countLabel.text = "0.0"
      config.blur = 0
    default:
      break
    }
    
    Cache.setConfig(config: config)
  }
  
}
