//
//  CameraViewController.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/5/19.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class CameraViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var capturePreviewImageView: UIImageView!
  @IBOutlet weak var functionView: UIView!
  @IBOutlet weak var toastLabel: UILabel!
  @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var albumView: UIView!
    @IBOutlet weak var shootView: UIView!
    @IBOutlet weak var galleryView: UIView!
  
  var watermarkView: WatermarkView?
  var functionScrollView: FunctionScrollView?
  var slideView: SlideView?
  let cameraController = CameraController()
  var locationManager: CLLocationManager!
  var viewDidAppeared = false // 第一次改为true
  
  override var prefersStatusBarHidden: Bool { return true }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let watermarkIsOn = Cache.getWatermarkConfig()
    if watermarkIsOn {
      watermarkView?.isHidden = false
    } else {
      watermarkView?.isHidden = true
    }
    
    let authorizationStatus = locationManager.authorizationStatus
    if (authorizationStatus == .authorizedWhenInUse) {
      locationManager.startUpdatingLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
    
    // 触发更新，否则画面会卡住。只有第一次不触发（因为viewDidLoad里触发了），后续一直触发
    if viewDidAppeared {
      cameraController.prepare {(error) in }
    } else {
      viewDidAppeared = true
    }
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //put code here
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    // 日期水印
    let watermarkViewNib = UINib(nibName: "WatermarkView", bundle: Bundle.main)
    watermarkView = watermarkViewNib.instantiate(withOwner: self, options: nil)[0] as! WatermarkView
    capturePreviewImageView.addSubview(watermarkView!)
    
    watermarkView?.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(capturePreviewImageView)
      make.right.equalTo(capturePreviewImageView)
      make.bottom.equalTo(capturePreviewImageView)
      make.left.equalTo(capturePreviewImageView)
    }

    // functionScrollView
    let functionScrollViewNib = UINib(nibName: "FunctionScrollView", bundle: Bundle.main)
    let functionScrollView = functionScrollViewNib.instantiate(withOwner: self, options: nil)[0] as! FunctionScrollView
  
    functionScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56)
    functionScrollView.contentSize = CGSize(width: 626, height: 56)
    self.functionScrollView = functionScrollView
    functionView.addSubview(functionScrollView)
    
    // 闪光灯事件
    let flashImageViewTap = MyTapGesture(target: self, action: #selector(clickFlash))
    functionScrollView.flashImageView.addGestureRecognizer(flashImageViewTap)
    // 翻转摄像头事件
    let flipImageViewTap = MyTapGesture(target: self, action: #selector(clickFlip))
    functionScrollView.flipImageView.addGestureRecognizer(flipImageViewTap)
    // 曝光事件
    let exposureImageViewTap = MyTapGesture(target: self, action: #selector(showSliderView))
    exposureImageViewTap.ref = "exposure"
    functionScrollView.exposureImageView.addGestureRecognizer(exposureImageViewTap)
    // 反差事件
    let contrastImageViewTap = MyTapGesture(target: self, action: #selector(showSliderView))
    contrastImageViewTap.ref = "contrast"
    functionScrollView.contrastImageView.addGestureRecognizer(contrastImageViewTap)
    // 锐化事件
    let sharpenImageViewTap = MyTapGesture(target: self, action: #selector(showSliderView))
    sharpenImageViewTap.ref = "sharpen"
    functionScrollView.sharpenImageView.addGestureRecognizer(sharpenImageViewTap)
    // 暗角事件
    let vignetteImageViewTap = MyTapGesture(target: self, action: #selector(showSliderView))
    vignetteImageViewTap.ref = "vignette"
    functionScrollView.vignetteImageView.addGestureRecognizer(vignetteImageViewTap)
    // 噪点事件
    let noiseImageViewTap = MyTapGesture(target: self, action: #selector(showSliderView))
    noiseImageViewTap.ref = "noise"
    functionScrollView.noiseImageView.addGestureRecognizer(noiseImageViewTap)
    // 模糊事件
    let blurImageViewTap = MyTapGesture(target: self, action: #selector(showSliderView))
    blurImageViewTap.ref = "blur"
    functionScrollView.blurImageView.addGestureRecognizer(blurImageViewTap)
    // 重置事件
    let resetImageViewTap = MyTapGesture(target: self, action: #selector(resetConfig))
    resetImageViewTap.ref = "blur"
    functionScrollView.resetImageView.addGestureRecognizer(resetImageViewTap)
  
    // 点击空白区域，隐藏sliderView
    let capturePreviewImageViewTap = MyTapGesture(target: self, action: #selector(hideSliderView))
    capturePreviewImageView.addGestureRecognizer(capturePreviewImageViewTap)
    
    // 点击相册事件
    let albumTap = MyTapGesture(target: self, action: #selector(showAlbum))
    albumView.addGestureRecognizer(albumTap)
    // 点击画廊事件
    let settingTap = MyTapGesture(target: self, action: #selector(showSetting))
    galleryView.addGestureRecognizer(settingTap)

    // 添加sliderView
    let slideViewNib = UINib(nibName: "SlideView", bundle: Bundle.main)
    slideView = slideViewNib.instantiate(withOwner: self, options: nil)[0] as! SlideView
    slideView!.frame = CGRect(x: 0, y: 56, width: UIScreen.main.bounds.width, height: 56)
    functionView.addSubview(slideView!)
    
    // 添加sliderView隐藏事件
    let downTap = MyTapGesture(target: self, action: #selector(hideSliderView))
    slideView?.downImageView.addGestureRecognizer(downTap)
    
    // 添加slider滑动事件
    slideView?.slider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)
    
    // toastLabel
    toastLabel.font = UIFont(name: "PingFangTC-Medium", size: 14)
    toastLabel.alpha = 0
    
    // 准备相机
    cameraController.delegate = self
    cameraController.prepare {(error) in
      if let error = error {
        print(error)
      }
      self.cameraController.previewView = self.capturePreviewImageView

      // 点击拍照事件
      let shootViewTap = MyTapGesture(target: self, action: #selector(self.captureImage))
      self.shootView.addGestureRecognizer(shootViewTap)
    }
  }
  
  // 切换闪光灯
  @objc func clickFlash() {
    Util.shake()
    let config: Photo = Cache.getConfig()
    
    switch config.flash ?? "off" {
    case "on":
      config.flash = "off"
      functionScrollView?.flashImageView.image = UIImage(named: "flash-off")
      showToast(message: NSLocalizedString("flash_off", comment: ""))
    case "off":
      config.flash = "auto"
      functionScrollView?.flashImageView.image = UIImage(named: "flash-auto")
      showToast(message: NSLocalizedString("flash_auto", comment: ""))
    case "auto":
      config.flash = "on"
      functionScrollView?.flashImageView.image = UIImage(named: "flash-on")
      showToast(message: NSLocalizedString("flash_on", comment: ""))
    default:
      config.flash = "off"
      functionScrollView?.flashImageView.image = UIImage(named: "flash-off")
      showToast(message: NSLocalizedString("flash_off", comment: ""))
    }
    Cache.setConfig(config: config)
  }
  
  // 切换摄像头
  @objc func clickFlip() {
    Util.shake()
    let config = Cache.getConfig()
    
    switch cameraController.currentCameraPosition {
    case .front:
      config.flip = "back"
    case .rear:
      config.flip = "front"
    default:
      break
    }
    
    try? cameraController.switchCameras()
    Cache.setConfig(config: config)
  }

  // 重置config
  @objc func resetConfig() {
    Util.shake()
    Cache.clearConfig()
    functionScrollView?.updateUI()
  }
  
  // 显示sliderView
  @objc func showSliderView(gesture: MyTapGesture) {
    Util.shake()
    
    let type = gesture.ref as! String
    // 自动设置slider和countLabel
    slideView?.type = type
    
    // 显示toast
    switch type {
    case "exposure":
      showToast(message: NSLocalizedString("exposure", comment: ""))
    case "contrast":
      showToast(message: NSLocalizedString("contrast", comment: ""))
    case "sharpen":
      showToast(message: NSLocalizedString("sharpen", comment: ""))
    case "vignette":
      showToast(message: NSLocalizedString("vignette", comment: ""))
    case "noise":
      showToast(message: NSLocalizedString("noise", comment: ""))
    case "blur":
    showToast(message: NSLocalizedString("blur", comment: ""))
    default:
      break
    }
    
    UIView.animate(withDuration: 0.25) {
      self.slideView?.frame = CGRect(x: 0, y: 0, width: self.slideView!.frame.width, height: self.slideView!.frame.height)
    }
  }
  
  // 隐藏sliderView
  @objc func hideSliderView() {
    // 未弹出状态，点击没反应
    if slideView?.frame.origin.y ?? 0.0 > 0.0 {
      return
    }
    Util.shake()
    // 更新数值
    functionScrollView?.updateUI()
    UIView.animate(withDuration: 0.25) {
      self.slideView?.frame = CGRect(x: 0, y: 56, width: self.slideView!.frame.width, height: self.slideView!.frame.height)
    }
  }
  
  // slider滑动事件
  @objc func changeSlider(_ slider: UISlider) {
    slideView?.countLabel.text = String(format: "%.1f", slideView?.slider.value ?? 0)
    
    let config: Photo = Cache.getConfig()
    let type = self.slideView?.type
    switch type {
    case "exposure":
      config.exposure = self.slideView?.slider.value
    case "contrast":
      config.contrast = self.slideView?.slider.value
    case "sharpen":
      config.sharpen = self.slideView?.slider.value
    case "vignette":
      config.vignette = self.slideView?.slider.value
    case "noise":
      config.noise = self.slideView?.slider.value
    case "blur":
      config.blur = self.slideView?.slider.value
    default:
      break
    }
    Cache.setConfig(config: config)
  }
  
  // 显示toast
  func showToast(message: String) {
    toastLabel.text = message
    UIView.animate(withDuration: 0.25) {
      self.toastLabel.alpha = 1
      UIView.animate(withDuration: 0.25, delay: 2, options: [], animations: {
        self.toastLabel.alpha = 0
      }, completion: nil)
    }
  }

  // 跳转相册
  @objc func showAlbum() {
    (self.parent as? PageViewController)?.backToAlbumViewController()
  }
  
  // 跳转画廊
  @objc func showSetting() {
    (self.parent as? PageViewController)?.forwardToSettingViewController()
  }
   
  // 拍照
  @objc func captureImage() {
    Util.shake()
    cameraController.captureImage {(image, error) in
      guard var image = image else {
        print(error ?? "Capture error")
        return
      }
      self.showToast(message: NSLocalizedString("saved", comment: ""))
      
      // 是否添加日期水印
      if Cache.getWatermarkConfig() == true {
        image = image.addWatermark()
      }
      PhotoUtil.shared.saveImage(image) { (error) in
        if let error = error {
          print(error)
          return
        }
      }
    }
  }
}
