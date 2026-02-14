//
//  SettingViewController.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/7/4.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var versionLabel: UILabel!
  
  var pageViewController: PageViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 导航栏
    navigationController?.navigationBar.topItem?.title = "设置"
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
    
    navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
    
    // 注册单元格
    let settingSwitchCellNib = UINib(nibName: "SettingSwitchCell", bundle: Bundle.main)
    tableView.register(settingSwitchCellNib, forCellReuseIdentifier: "SettingSwitchCell")
    let settingNormalCellNib = UINib(nibName: "SettingNormalCell", bundle: Bundle.main)
    tableView.register(settingNormalCellNib, forCellReuseIdentifier: "SettingNormalCell")
    
    // 解决进来不显示大标题的问题
    tableView.contentInsetAdjustmentBehavior = .never
    
    // versionLabel
    versionLabel.font = UIFont(name: "Gotham-Book", size: 12)
    versionLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    versionLabel.text = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
  }
  
  @objc func back() {
    Util.shake()
    pageViewController?.backToCameraViewController()
  }
  
  @objc func getPro() {
    Cache.setLoselessConfig(on: (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingSwitchCell).proSwitch.isOn)
    Cache.setWatermarkConfig(on: (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingSwitchCell).proSwitch.isOn)
    Cache.setLocationConfig(on: (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingSwitchCell).proSwitch.isOn)
  }
  
  @objc func sendEmail() {
    if MFMailComposeViewController.canSendMail(){//是否可以发邮件 // 如果不能,去系统设置接收邮箱
      let mailView = MFMailComposeViewController()
      mailView.mailComposeDelegate = self
      mailView.setToRecipients(["ravencam@nswbmw.com"])
      mailView.setSubject("RavenCam - 意见反馈")
      mailView.setMessageBody("", isHTML: false)
      self.present(mailView, animated: false, completion: nil)
    } else {
      let alert = UIAlertController.init(title: "联系我们", message: "请发送邮件到 ravencam@nswbmw.com", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction.init(title: "确定", style: UIAlertAction.Style.default, handler: { (alert) in
      }))
      self.present(alert, animated: false, completion: nil)
    }
  }
  
  //用户退出邮件窗口时被调用
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      controller.dismiss(animated: true, completion: nil)
  }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 3
    }
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }


  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
    return sectionView
  }

  // cell 内容
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.section == 0 {
      var cell: SettingSwitchCell!
      if indexPath.row == 0 {
        cell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingSwitchCell
        cell.titleLabel.text = "无损拍摄"
        cell.proSwitch.isOn = Cache.getLoselessConfig()
      } else if indexPath.row == 1 {
        cell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingSwitchCell
        cell.titleLabel.text = "日期水印"
        cell.proSwitch.isOn = Cache.getWatermarkConfig()
      } else {
        cell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingSwitchCell
        cell.titleLabel.text = "地理位置"
        cell.proSwitch.isOn = Cache.getLocationConfig()
      }
      
      // 添加点击switch事件
      cell.proSwitch.addTarget(self, action: #selector(getPro), for: .valueChanged)

      return cell
    } else {
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNormalCell") as! SettingNormalCell
        cell.titleLabel.text = "意见反馈"
        return cell
      } else if indexPath.row == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNormalCell") as! SettingNormalCell
        cell.titleLabel.text = "应用评分"
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNormalCell") as! SettingNormalCell
        cell.titleLabel.text = "其他作品"
        return cell
      }
    }
  }
  
  // cell 点击
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      if indexPath.row == 0 {
        sendEmail()
      } else if indexPath.row == 1 {
        let urlString = "itms-apps://itunes.apple.com/app/id1527902937"
        if let url = URL(string: urlString) {
          UIApplication.shared.open(url)
        }
      } else if indexPath.row == 2 {
        let urlString = "itms-apps://itunes.apple.com/developer/id1369823343"
        if let url = URL(string: urlString) {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}
