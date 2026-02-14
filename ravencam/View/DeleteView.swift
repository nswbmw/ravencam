//
//  DeleteView.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2021/8/13.
//  Copyright © 2021 nswbmw. All rights reserved.
//


import UIKit

class DeleteView: UIView {

  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var okLabel: UILabel!
  @IBOutlet weak var cancelLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    tipLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
    tipLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    
    okLabel.font = UIFont(name: "PingFangSC-Regular", size: 16)
    okLabel.textColor = UIColor.white
    
    cancelLabel.font = UIFont(name: "PingFangSC-Regular", size: 16)
    cancelLabel.textColor = UIColor.white
  }
}
