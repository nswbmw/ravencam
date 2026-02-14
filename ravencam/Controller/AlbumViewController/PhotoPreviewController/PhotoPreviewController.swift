//
//  PhotoPreviewController.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/7/2.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import Photos

//图片浏览控制器
class PhotoPreviewController: UIViewController {
  
  //存储图片数组
  var assets:[PHAsset]
  let options: PHImageRequestOptions = {
    let _options = PHImageRequestOptions()
    _options.isSynchronous = true
    return _options
  }()

  //默认显示的图片索引
  var index:Int
  
  // 4个功能项
  var imagePreviewFunctionView: ImagePreviewFunctionView!
  
  // 查看参数
  var photoArgumentsView: PhotoArgumentsView!
  
  // 分享
  var shareView: ShareView!
  
  @IBOutlet weak var collectionView: UICollectionView!

  //初始化
  init(assets:[PHAsset], index:Int = 0){
    self.assets = assets
    self.index = index
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    //将视图滚动到默认图片上。放到这里，放到viewDidLoad里ui可能没加载完，不准确。放到viewDidAppear会先显示第一张图片后切换到选定的图片
    let indexPath = IndexPath(item: index, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
  }
  
  //初始化
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //collectionView尺寸样式设置
    let collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.minimumLineSpacing = 0
    collectionViewLayout.minimumInteritemSpacing = 0
    collectionViewLayout.scrollDirection = .horizontal
    collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
    
    // 注册单元格
    collectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: "cell")
    
    //不自动调整内边距，确保全屏
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.layoutIfNeeded() // 不加不会生效！！！
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false

    // 4个功能项
    let imagePreviewFunctionViewNib = UINib(nibName: "ImagePreviewFunctionView", bundle: Bundle.main)
    let imagePreviewFunctionView = imagePreviewFunctionViewNib.instantiate(withOwner: self, options: nil)[0] as! ImagePreviewFunctionView
    imagePreviewFunctionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 114, width: UIScreen.main.bounds.width, height: 80)
    self.imagePreviewFunctionView = imagePreviewFunctionView
    view.addSubview(imagePreviewFunctionView)
    
    // 照片参数
    let photoArgumentsViewNib = UINib(nibName: "PhotoArgumentsView", bundle: Bundle.main)
    let photoArgumentsView = photoArgumentsViewNib.instantiate(withOwner: self, options: nil)[0] as! PhotoArgumentsView
    photoArgumentsView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 220, width: UIScreen.main.bounds.width, height: 197)
    view.addSubview(photoArgumentsView)
    let asset = assets[index]
    self.photoArgumentsView = photoArgumentsView
    self.photoArgumentsView?.key = asset.localIdentifier
    self.photoArgumentsView.isHidden = true
    
    // 分享
    let shareViewNib = UINib(nibName: "ShareView", bundle: Bundle.main)
    let shareView = shareViewNib.instantiate(withOwner: self, options: nil)[0] as! ShareView
    shareView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    self.shareView = shareView
    view.addSubview(shareView)
    //单击监听
    let tapSingle=UITapGestureRecognizer(target:self, action:#selector(tapSingleDid))
    tapSingle.numberOfTapsRequired = 1
    tapSingle.numberOfTouchesRequired = 1
    self.shareView.addGestureRecognizer(tapSingle)
    self.shareView.isHidden = true
    
    /*  事件  */
    // 关闭预览
    let closeTap = MyTapGesture(target: self, action: #selector(closeTap))
    imagePreviewFunctionView.closeImageView.addGestureRecognizer(closeTap)
    
    // 显示参数
    let showArgumentsTap = MyTapGesture(target: self, action: #selector(showArguments))
    imagePreviewFunctionView.infoImageView.addGestureRecognizer(showArgumentsTap)
    
    // 分享图片
    let shareViewTap = MyTapGesture(target: self, action: #selector(sharePhoto))
    imagePreviewFunctionView.shareImageView.addGestureRecognizer(shareViewTap)
    
    // 删除图片
    let deleteViewTap = MyTapGesture(target: self, action: #selector(deletePhoto))
    imagePreviewFunctionView.trashImageView.addGestureRecognizer(deleteViewTap)
    
  }
  
  //图片单击事件响应
  @objc func tapSingleDid(_ ges:UITapGestureRecognizer){
    self.shareView.isHidden = true
    self.photoArgumentsView.isHidden = true
  }
  
  //隐藏状态栏
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // 关闭预览
  @objc func closeTap () {
    Util.shake()
    self.dismiss(animated: true, completion: nil)
  }
  
  // 显示参数
  @objc func showArguments () {
    Util.shake()
    photoArgumentsView.isHidden = false
  }
  
  // 分享图片
  @objc func sharePhoto () {
    Util.shake()
    
    self.shareView.isHidden = false
  }
  
  // 删除图片
  @objc func deletePhoto () {
    Util.shake()
    
    let asset = self.assets[self.index]
    
    PHPhotoLibrary.shared().performChanges {
        PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
    } completionHandler: { success, error in
      if (success) {
        DispatchQueue.main.async {
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
  }
  
}

extension PhotoPreviewController: UICollectionViewDelegate, UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout {
  
  // cell 内容
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagePreviewCell
    cell.parentCV = self
    let asset = assets[indexPath.row]
    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { (img, info) in
      if let img = img {
        cell.imageView.image = img
      }
    })
    return cell
  }
  
  // cell 数量
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.assets.count
  }
  
  // cell 布局
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.collectionView.bounds.size
  }
  
  // cell 显示
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? ImagePreviewCell{
      //由于单元格是复用的，所以要重置内部元素尺寸
      cell.resetSize()
      let asset = assets[indexPath.row]
      self.photoArgumentsView?.key = asset.localIdentifier
    }
  }
  
  // 通过偏移计算索引
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    index = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
  }
}
