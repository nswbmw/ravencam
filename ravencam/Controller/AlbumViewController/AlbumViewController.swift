//
//  AlbumViewController.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/24.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import Photos

class AlbumViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  
  var pageViewController: PageViewController?
  
  var assets: [PHAsset] = []
  let options: PHImageRequestOptions = {
    let _options = PHImageRequestOptions()
    _options.isSynchronous = true
    return _options
  }()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    assets = PhotoUtil.shared.getAllAssets()
    collectionView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 导航栏
    navigationController?.navigationBar.topItem?.title = "相册"
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .automatic
    navigationController?.navigationBar.largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(forward))

    // 注册单元格
    let albumCollectionViewCellNib = UINib(nibName: "AlbumCollectionViewCell", bundle: Bundle.main)
    collectionView.register(albumCollectionViewCellNib, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
    
    // 布局
    let flowLayout = UICollectionViewFlowLayout()
    let cellWidth = (UIScreen.main.bounds.size.width - 18 * 3) / 2
    flowLayout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
    flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    flowLayout.minimumLineSpacing = 18
    flowLayout.minimumInteritemSpacing = 18
    collectionView.setCollectionViewLayout(flowLayout, animated: true)
  }
  
  @objc func forward() {
    self.pageViewController?.forwardToCameraViewController()
  }
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  // cell 数
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assets.count
  }
  
  // cell 内容
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
    let asset = assets[indexPath.row]
    
    PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { (img, info) in
      if let img = img {
        cell.image = img
      }
    })
    return cell
  }
  
  // cell 点击
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    Util.shake()
    
    //进入图片全屏展示
    let photoPreviewController = PhotoPreviewController(assets: assets, index: indexPath.row)
    let previewNav = UINavigationController(rootViewController: photoPreviewController)
    previewNav.modalPresentationStyle = .fullScreen
    previewNav.setNavigationBarHidden(true, animated: false)
    self.present(previewNav, animated: true, completion: nil)
  }
}
