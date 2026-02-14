//
//  ShareView.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2021/8/13.
//  Copyright © 2021 nswbmw. All rights reserved.
//


import UIKit

class ShareView: UIView {

  @IBOutlet weak var weixinView: UIStackView!
    @IBOutlet weak var weixinLabel: UILabel!
  
  @IBOutlet weak var pengyouquanView: UIStackView!
    @IBOutlet weak var pengyouquanLabel: UILabel!
  
  @IBOutlet weak var weiboView: UIStackView!
    @IBOutlet weak var weiboLabel: UILabel!
  
  @IBOutlet weak var qqView: UIStackView!
    @IBOutlet weak var qqLabel: UILabel!
  
  @IBOutlet weak var cancelLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    weixinLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    weixinLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    pengyouquanLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    pengyouquanLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    weiboLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    weiboLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    qqLabel.font = UIFont(name: "PingFangSC-Light", size: 12)
    qqLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)

    cancelLabel.font = UIFont(name: "PingFangSC-Regular", size: 16)
    cancelLabel.textColor = UIColor.white
  }
}
