//
//  FunctionScrollView.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/27.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class FunctionScrollView: UIScrollView {

  @IBOutlet weak var flashImageView: UIImageView!
  
  @IBOutlet weak var flipImageView: UIImageView!
  
  @IBOutlet weak var exposureImageView: UIImageView!
  @IBOutlet weak var exposureCountLabel: UILabel!
  
  @IBOutlet weak var contrastImageView: UIImageView!
  @IBOutlet weak var contrastCountLabel: UILabel!
  
  @IBOutlet weak var sharpenImageView: UIImageView!
  @IBOutlet weak var sharpenCountLabel: UILabel!
  
  @IBOutlet weak var vignetteImageView: UIImageView!
  @IBOutlet weak var vignetteCountLabel: UILabel!
  
  @IBOutlet weak var noiseImageView: UIImageView!
  @IBOutlet weak var noiseCountLabel: UILabel!
  
  @IBOutlet weak var blurImageView: UIImageView!
  @IBOutlet weak var blurCountLabel: UILabel!
  
  @IBOutlet weak var resetImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // 曝光
    exposureCountLabel.font = UIFont(name: "Gotham-Book", size: 9)
    exposureCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    exposureCountLabel.isHidden = true
    
    // 反差
    contrastCountLabel.font = UIFont(name: "Gotham-Book", size: 9)
    contrastCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    contrastCountLabel.isHidden = true
    
    // 锐化
    sharpenCountLabel.font = UIFont(name: "Gotham-Book", size: 9)
    sharpenCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    sharpenCountLabel.isHidden = true
    
    // 暗角
    vignetteCountLabel.font = UIFont(name: "Gotham-Book", size: 9)
    vignetteCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    vignetteCountLabel.isHidden = true
    
    // 噪点
    noiseCountLabel.font = UIFont(name: "Gotham-Book", size: 9)
    noiseCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    noiseCountLabel.isHidden = true
    
    // 模糊
    blurCountLabel.font = UIFont(name: "Gotham-Book", size: 9)
    blurCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    blurCountLabel.isHidden = true
    
    updateUI()
  }
  
  // 更新UI
  func updateUI() {
    let config = Cache.getConfig()

    // 闪光灯
    switch config.flash ?? "off" {
    case "on":
      flashImageView.image = UIImage(named: "flash-on")
    case "off":
      flashImageView.image = UIImage(named: "flash-off")
    case "auto":
      flashImageView.image = UIImage(named: "flash-auto")
    default:
      flashImageView.image = UIImage(named: "flash-off")
    }
    
    // 曝光
    if (config.exposure ?? 0).toFixed(1) != 0 {
      exposureCountLabel.text = config.exposure! > 0 ? "+" + String(format: "%.1f", config.exposure!) : String(format: "%.1f", config.exposure!)
      exposureCountLabel.isHidden = false
    } else {
      exposureCountLabel.isHidden = true
    }
    // 反差
    if (config.contrast ?? 0).toFixed(1) != 0 {
      contrastCountLabel.text = config.contrast! > 0 ? "+" + String(format: "%.1f", config.contrast!) : String(format: "%.1f", config.contrast!)
      contrastCountLabel.isHidden = false
    } else {
      contrastCountLabel.isHidden = true
    }
    // 锐化
    if (config.sharpen ?? 0).toFixed(1) != 0 {
      sharpenCountLabel.text = config.sharpen! > 0 ? "+" + String(format: "%.1f", config.sharpen!) : String(format: "%.1f", config.sharpen!)
      sharpenCountLabel.isHidden = false
    } else {
      sharpenCountLabel.isHidden = true
    }
    // 暗角
    if (config.vignette ?? 0).toFixed(1) != 0 {
      vignetteCountLabel.text = config.vignette! > 0 ? "+" + String(format: "%.1f", config.vignette!) : String(format: "%.1f", config.vignette!)
      vignetteCountLabel.isHidden = false
    } else {
      vignetteCountLabel.isHidden = true
    }
    // 噪点
    if (config.noise ?? 0).toFixed(1) != 0 {
      noiseCountLabel.text = config.noise! > 0 ? "+" + String(format: "%.1f", config.noise!) : String(format: "%.1f", config.noise!)
      noiseCountLabel.isHidden = false
    } else {
      noiseCountLabel.isHidden = true
    }
    // 模糊
    if (config.blur ?? 0).toFixed(1) != 0 {
      blurCountLabel.text = config.blur! > 0 ? "+" + String(format: "%.1f", config.blur!) : String(format: "%.1f", config.blur!)
      blurCountLabel.isHidden = false
    } else {
      blurCountLabel.isHidden = true
    }
  }
}
