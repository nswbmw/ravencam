//
//  WatermarkView.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2021/8/14.
//  Copyright © 2021 nswbmw. All rights reserved.
//

import UIKit

class WatermarkView: UIView {

  @IBOutlet weak var watermarkLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    watermarkLabel.text = Util.getTime()
    watermarkLabel.font = UIFont(name: "ElectronicHighwaySign", size: 14)
    watermarkLabel.textColor = UIColor.white
  }
}
