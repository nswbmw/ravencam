//
//  CameraController.swift
//  AV Foundation
//
//  Created by Pranjal Satija on 29/5/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import AVFoundation
import UIKit
import Photos

class CameraController: NSObject {
  var delegate: CameraViewController?

  var captureSession: AVCaptureSession?
  
  var currentCameraPosition: CameraPosition?
  
  var frontCamera: AVCaptureDevice?
  var frontCameraInput: AVCaptureDeviceInput?
  
  var rearCamera: AVCaptureDevice?
  var rearCameraInput: AVCaptureDeviceInput?

  var photoOutput: AVCapturePhotoOutput?
  var videoOutput: AVCaptureVideoDataOutput?
  
  var previewView: UIImageView?
  var previewLayer: AVCaptureVideoPreviewLayer?
  
  var flashMode = AVCaptureDevice.FlashMode.off
  var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?

  let ciContext = CIContext(options:nil)
}

extension CameraController {
  func prepare(completionHandler: @escaping (Error?) -> Void) {
    
    func createCaptureSession() {
      self.captureSession = AVCaptureSession()
      self.captureSession?.automaticallyConfiguresCaptureDeviceForWideColor = false
    }
    
    func configureCaptureDevices() throws {
      let session = AVCaptureDevice.DiscoverySession(deviceTypes: [
        .builtInWideAngleCamera,
        .builtInUltraWideCamera,
        .builtInTelephotoCamera
      ], mediaType: .video, position: .unspecified)
      let cameras = session.devices
      guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }

      for camera in cameras {
        if camera.position == .front {
          self.frontCamera = camera
        }
        
        if camera.position == .back {
          self.rearCamera = camera
          
          try camera.lockForConfiguration()
          camera.focusMode = .continuousAutoFocus
          camera.unlockForConfiguration()
        }
      }
    }
    
    // 输入流
    func configureDeviceInputs() throws {
      guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
      
      if let rearCamera = self.rearCamera {
        self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
        if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
        self.currentCameraPosition = .rear
      }
        
      else if let frontCamera = self.frontCamera {
        self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
        else { throw CameraControllerError.inputsAreInvalid }
        self.currentCameraPosition = .front
      }
        
      else { throw CameraControllerError.noCamerasAvailable }
    }
    
    // 输出流
    func configurePhotoOutput() throws {
      guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
      self.photoOutput = AVCapturePhotoOutput()
      let photoSettings = AVCapturePhotoSettings(format: [
        AVVideoCodecKey: AVVideoCodecType.jpeg
      ])
      self.photoOutput?.setPreparedPhotoSettingsArray([photoSettings], completionHandler: nil)
      self.photoOutput?.isHighResolutionCaptureEnabled = Cache.getLoselessConfig()

      if captureSession.canAddOutput(self.photoOutput!) {
        captureSession.addOutput(self.photoOutput!)
      }
    }
    
    // video输出流
    func configureVideoOutput() throws {
      guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
      self.videoOutput = AVCaptureVideoDataOutput()
      self.videoOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.main)
      
      if captureSession.canAddOutput(self.videoOutput!) {
        captureSession.addOutput(self.videoOutput!)
      }
    }
    
    // 初始化工作
    DispatchQueue.main.async {
      do {
        createCaptureSession()
        try configureCaptureDevices()
        try configureDeviceInputs()
        try configurePhotoOutput()
        try configureVideoOutput()
        self.captureSession?.startRunning()
      } catch {
        DispatchQueue.main.async {
          completionHandler(error)
        }
        return
      }
      
      DispatchQueue.main.async {
        completionHandler(nil)
      }
    }
  }
  
  // 切换摄像头
  func switchCameras() throws {
    guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
    
    // 修改 captureSession
    captureSession.beginConfiguration()
    
    // 切换前置摄像头
    func switchToFrontCamera() throws {
      guard let rearCameraInput = self.rearCameraInput, captureSession.inputs.contains(rearCameraInput),
        let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
      
      self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
      
      captureSession.removeInput(rearCameraInput)
      
      if captureSession.canAddInput(self.frontCameraInput!) {
        captureSession.addInput(self.frontCameraInput!)
        
        self.currentCameraPosition = .front
      } else {
        throw CameraControllerError.invalidOperation
      }
    }
    
    // 切换后置摄像头
    func switchToRearCamera() throws {
      guard let frontCameraInput = self.frontCameraInput, captureSession.inputs.contains(frontCameraInput), let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
      
      self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
      
      captureSession.removeInput(frontCameraInput)
      
      if captureSession.canAddInput(self.rearCameraInput!) {
        captureSession.addInput(self.rearCameraInput!)
        
        self.currentCameraPosition = .rear
      }
        
      else { throw CameraControllerError.invalidOperation }
    }
    
    switch currentCameraPosition {
    case .front:
      try switchToRearCamera()
      
    case .rear:
      try switchToFrontCamera()
    }
    
    // 提交修改 captureSession
    captureSession.commitConfiguration()
  }
  
  // 拍照
  func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
    guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
    
    let config = Cache.getConfig()
    let settings = AVCapturePhotoSettings()
    // 闪光灯设置
    switch config.flash ?? "off" {
    case "on":
      flashMode = .on
    case "off":
      flashMode = .off
    case "auto":
      flashMode = .auto
    default:
      flashMode = .off
    }
    
    settings.flashMode = flashMode
    // 高清拍摄
    settings.isHighResolutionPhotoEnabled = Cache.getLoselessConfig()
    
    self.photoOutput?.capturePhoto(with: settings, delegate: self)
    self.photoCaptureCompletionBlock = completion
  }
  
  // 使用滤镜处理图片
  func filterImage(ciInputImage: CIImage) -> UIImage {
    let config = Cache.getConfig()
    
    let ciFilter = CIFilter(name: "CIPhotoEffectNoir")
    ciFilter!.setValue(ciInputImage, forKey: kCIInputImageKey)
    var ciOutputImage = ciFilter!.outputImage!
    
    // 曝光
    if (config.exposure ?? 0 != 0) {
      let exposureFilter = CIFilter(name: "CIExposureAdjust")
      exposureFilter?.setValue(ciOutputImage, forKey: kCIInputImageKey)
      exposureFilter?.setValue(config.exposure! / 2, forKey: "inputEV")

      ciOutputImage = exposureFilter!.outputImage!
    }
    
    // 反差
    if (config.contrast ?? 0 != 0) {
      let contrastFilter = CIFilter(name: "CIColorControls")
      contrastFilter?.setValue(ciOutputImage, forKey: kCIInputImageKey)
      contrastFilter?.setValue(1 + config.contrast! / 15, forKey: "inputContrast")

      ciOutputImage = contrastFilter!.outputImage!
    }
    
    // 锐化
    if (config.sharpen ?? 0 != 0) {
      let sharpenFilter = CIFilter(name: "CIUnsharpMask")
      sharpenFilter?.setValue(ciOutputImage, forKey: kCIInputImageKey)
      sharpenFilter?.setValue(config.sharpen!, forKey: "inputRadius")

      ciOutputImage = sharpenFilter!.outputImage!
    }
    
    // 暗角
    if (config.vignette ?? 0 != 0) {
      let vignetteFilter = CIFilter(name: "CIVignette")
      vignetteFilter?.setValue(ciOutputImage, forKey: kCIInputImageKey)
      vignetteFilter?.setValue(2.5, forKey: "inputIntensity")
      vignetteFilter?.setValue(config.vignette! / 5, forKey: "inputRadius")
      
      ciOutputImage = vignetteFilter!.outputImage!
    }
    
    // 噪点
    if (config.noise ?? 0 != 0) {
      let randomGeneratorFilter = CIFilter(name: "CIRandomGenerator")
      let colorMatrixFilter = CIFilter(name: "CIColorMatrix")
      colorMatrixFilter?.setValue(randomGeneratorFilter?.outputImage!, forKey: kCIInputImageKey)
      
      colorMatrixFilter?.setValue(CIVector(x: 0, y: 1, z: 0), forKey: "inputRVector")
      colorMatrixFilter?.setValue(CIVector(x: 0, y: 1, z: 0), forKey: "inputGVector")
      colorMatrixFilter?.setValue(CIVector(x: 0, y: 1, z: 0), forKey: "inputBVector")
      
      let opacity: CGFloat = CGFloat(0.01 + (config.noise! - 1) / 100)
      let overlayRgba: [CGFloat] = [0, 0, 0, opacity]
      let alphaVector: CIVector = CIVector(values: overlayRgba, count: 4)
      colorMatrixFilter?.setValue(alphaVector, forKey: "inputAVector")
      colorMatrixFilter?.setValue(CIVector(x: 0, y: 0, z: 0), forKey: "inputBiasVector")
      
      let sourceOverCompositingFilter = CIFilter(name: "CISourceOverCompositing")
      sourceOverCompositingFilter!.setValue(ciOutputImage, forKey: kCIInputBackgroundImageKey )
      sourceOverCompositingFilter!.setValue(colorMatrixFilter?.outputImage, forKey: kCIInputImageKey)

      ciOutputImage = sourceOverCompositingFilter!.outputImage!
    }

    // 模糊
    if (config.blur ?? 0 != 0) {
      let blurFilter = CIFilter(name: "CIMotionBlur")
      blurFilter!.setValue(ciOutputImage, forKey: kCIInputImageKey)
      blurFilter?.setValue(config.blur! * 2, forKey: "inputRadius")
      blurFilter?.setValue(90, forKey: "inputAngle")

      ciOutputImage = blurFilter!.outputImage!
    }
    
    let cgImage = ciContext.createCGImage(ciOutputImage, from: ciInputImage.extent)
    if currentCameraPosition == .rear {
      return UIImage(cgImage: cgImage!, scale: 1, orientation: UIImage.Orientation.right)
    } else {
      return UIImage(cgImage: cgImage!, scale: 1, orientation: UIImage.Orientation.leftMirrored)
    }
  }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
  // 处理拍照后的图片
  public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
            resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
    if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
    else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
      
      // 裁切成 3/4
      var ciInputImage = CIImage(data: data)
      let curWidth = ciInputImage!.extent.width
      let curHeight = ciInputImage!.extent.height
      let afterHeight = curHeight
      let afterWidth = afterHeight * 4 / 3
      ciInputImage = ciInputImage?.cropped(to: CGRect(x: (curWidth - afterWidth) / 2, y: 0, width: afterWidth, height: afterHeight))
      
      let image = self.filterImage(ciInputImage: ciInputImage!)
      
      self.photoCaptureCompletionBlock?(image, nil)
    } else {
      self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
    }
  }
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
  // 处理视频帧
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
    let ciInputImage = CIImage(cvImageBuffer: pixelBuffer!)
    let image = self.filterImage(ciInputImage: ciInputImage)
    self.previewView?.image = image
  }
}

  
extension CameraController {
  enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
  }
  
  public enum CameraPosition {
    case front
    case rear
  }
}
