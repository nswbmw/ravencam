//
//  PhotoArgumentsView.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/7/2.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class PhotoArgumentsView: UIView {

  @IBOutlet weak var flashLabel: UILabel!
  @IBOutlet weak var flashCountLabel: UILabel!

  @IBOutlet weak var flipLabel: UILabel!
  @IBOutlet weak var flipCountLabel: UILabel!

  @IBOutlet weak var exposureLabel: UILabel!
  @IBOutlet weak var exposureCountLabel: UILabel!

  @IBOutlet weak var contrastLabel: UILabel!
  @IBOutlet weak var contrastCountLabel: UILabel!

  @IBOutlet weak var sharpenLabel: UILabel!
  @IBOutlet weak var sharpenCountLabel: UILabel!

  @IBOutlet weak var vignetteLabel: UILabel!
  @IBOutlet weak var vignetteCountLabel: UILabel!

  @IBOutlet weak var noiseLabel: UILabel!
  @IBOutlet weak var noiseCountLabel: UILabel!

  @IBOutlet weak var blurLabel: UILabel!
  @IBOutlet weak var blurCountLabel: UILabel!

  var key: String? {
    didSet {
      if key == nil {
        return
      }
      let imageInfo = Cache.getImageInfo(key: key!)
      flashCountLabel.text = imageInfo.flash
      flipCountLabel.text = imageInfo.flip
      exposureCountLabel.text = String(format: "%.1f", imageInfo.exposure!)
      contrastCountLabel.text = String(format: "%.1f", imageInfo.contrast!)
      sharpenCountLabel.text = String(format: "%.1f", imageInfo.sharpen!)
      vignetteCountLabel.text = String(format: "%.1f", imageInfo.vignette!)
      noiseCountLabel.text = String(format: "%.1f", imageInfo.noise!)
      blurCountLabel.text = String(format: "%.1f", imageInfo.blur!)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    flashLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    flashLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    flashLabel.text = NSLocalizedString("flash", comment: "")
    flashCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    flashCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    flashCountLabel.text = "off"

    flipLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    flipLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    flipLabel.text = NSLocalizedString("camera", comment: "")
    flipCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    flipCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    flipCountLabel.text = "back"

    exposureLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    exposureLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    exposureLabel.text = NSLocalizedString("exposure", comment: "")
    exposureCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    exposureCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    exposureCountLabel.text = "0.0"

    contrastLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    contrastLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    contrastLabel.text = NSLocalizedString("contrast", comment: "")
    contrastCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    contrastCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    contrastCountLabel.text = "0.0"

    sharpenLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    sharpenLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    sharpenLabel.text = NSLocalizedString("sharpen", comment: "")
    sharpenCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    sharpenCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    sharpenCountLabel.text = "0.0"

    vignetteLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    vignetteLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    vignetteLabel.text = NSLocalizedString("vignette", comment: "")
    vignetteCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    vignetteCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    vignetteCountLabel.text = "0.0"

    noiseLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    noiseLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    noiseLabel.text = NSLocalizedString("noise", comment: "")
    noiseCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    noiseCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    noiseCountLabel.text = "0.0"

    blurLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    blurLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    blurLabel.text = NSLocalizedString("blur", comment: "")
    blurCountLabel.font = UIFont(name: "Gotham-Book", size: 18)
    blurCountLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    blurCountLabel.text = "0.0"
  }
}
