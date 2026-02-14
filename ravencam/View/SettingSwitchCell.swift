//
//  SettingSwitchCell.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/7/4.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class SettingSwitchCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var proSwitch: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 15)
    titleLabel.textColor = UIColor.white
    
    proSwitch.thumbTintColor = UIColor.white
    proSwitch.onTintColor = UIColor(red: 168/255.0, green: 172/255.0, blue: 176/255.0, alpha: 1)
    // 默认在左侧(关闭)
    proSwitch.isOn = false
  }
}
