//
//  SettingNormalCell.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/7/4.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class SettingNormalCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 15)
    titleLabel.textColor = UIColor.white
  }

}
