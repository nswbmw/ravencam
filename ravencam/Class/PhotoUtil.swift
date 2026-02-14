//
//  PhotoUtil.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/25.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import Photos

class PhotoUtil: NSObject {

    private var assetCollection:PHAssetCollection!
    private var albumFound:Bool = false
    private var photoAsset:PHFetchResult<AnyObject>!
    private var collection:PHAssetCollection!
    private var assetCollectionPlaceholder:PHObjectPlaceholder!
    private var albumName = "RavenCam"
    private var image:UIImage!

    static let shared = PhotoUtil()
    private override init() {}

    func createAlbum(completed: ((_ error:Error?)->())?) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate.init(format: "title = %@", albumName)
        let collection : PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        if let _ = collection.firstObject{
            self.albumFound = true
            assetCollection = collection.firstObject
            self.saveImage(completed: completed)
        }else{
            PHPhotoLibrary.shared().performChanges({
                let creatAlbumRequest:PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
                self.assetCollectionPlaceholder = creatAlbumRequest.placeholderForCreatedAssetCollection
            }) { (result, error) in
                if result{
                    self.albumFound = result
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [self.assetCollectionPlaceholder.localIdentifier], options: nil)
                    self.assetCollection = collectionFetchResult.firstObject
                    self.saveImage(completed: completed)
                }else{
                    completed?(error)
                }
            }
        }
    }
    private func saveImage(completed: ((_ error:Error?)->())?) {
        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let assetPlaceholder = assetRequest.placeholderForCreatedAsset
          
            // 保存图片源信息
            Cache.setImageInfo(key: assetPlaceholder!.localIdentifier, info: Cache.getConfig())
          
          // 添加地理位置信息
          if Cache.getLocationConfig() {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            // 授权允许
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
              let location = CLLocationManager().location
              if location != nil {
                assetRequest.location = location
              }
            }
          }
          
            let albumChangeRequest = PHAssetCollectionChangeRequest.init(for: self.assetCollection)
            albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)

        }) { (result, error) in
            completed?(error)
        }
    }
    func saveImage(_ image:UIImage,completed: ((_ error:Error?)->())?) {
        self.image = image
        createAlbum(completed: completed)
    }
   func getImageCollectionFromTitle(_ name:String)->PHAssetCollection?{
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var array:[PHAssetCollection] = []

        result.enumerateObjects { (collection, index, _) in
            array.append(collection)
        }
        for item in array{
            if item.localizedTitle == self.albumName{
                return item
            }
        }
        return nil
    }
    func enumerateAssets(assetCollection: PHAssetCollection?)->[PHAsset] {
        var assetsArr:[PHAsset] = []

        var assets: PHFetchResult<PHAsset>? = nil
        if let aCollection = assetCollection {
            let fetchOption = PHFetchOptions()
          fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            assets = PHAsset.fetchAssets(in: aCollection, options: fetchOption)
        }
        assets?.enumerateObjects({ (asset, index, _) in
          assetsArr.append(asset)
        })
        return assetsArr
    }
  func getAllAssets() ->[PHAsset] {
    let assetCollection = self.getImageCollectionFromTitle(albumName)
    return self.enumerateAssets(assetCollection: assetCollection)
  }
}
