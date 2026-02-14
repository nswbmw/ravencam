//
//  AlbumCollectionViewCell.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/24.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var photoImageView: UIImageView!
  
  var image: UIImage? {
    didSet {
      if image == nil {
        return
      }
      photoImageView.image = image
    }
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
}
