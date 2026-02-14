//
//  PageViewController.swift
//  ravencam
//
//  Created by nswbmw's Mac on 2020/6/24.
//  Copyright © 2020 nswbmw. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

  //所有页面的视图控制器
  private(set) lazy var allViewControllers: [UIViewController] = {
    let albumViewController = AlbumViewController()
    albumViewController.pageViewController = self
    let albumNavController = UINavigationController(rootViewController: albumViewController)
    
    // 不嵌在nav里
    let cameraViewController = CameraViewController()
    
    let settingViewController = SettingViewController()
    settingViewController.pageViewController = self
    let settingNavController = UINavigationController(rootViewController: settingViewController)
    
    return [albumNavController, cameraViewController, settingNavController]
  }()

  //页面加载完毕
  override func viewDidLoad() {
    super.viewDidLoad()

//    dataSource = self

    //设置首页
    setViewControllers([allViewControllers[1]], direction: .forward, animated: true, completion: nil)

  }
  
  func forwardToCameraViewController() {
    Util.shake()
    setViewControllers([allViewControllers[1]], direction: .forward, animated: true, completion: nil)
  }
  
  func backToAlbumViewController() {
    Util.shake()
    setViewControllers([allViewControllers[0]], direction: .reverse, animated: true, completion: nil)
  }
  
  func forwardToSettingViewController() {
    Util.shake()
    setViewControllers([allViewControllers[2]], direction: .forward, animated: true, completion: nil)
  }
  
  func backToCameraViewController() {
    Util.shake()
    setViewControllers([allViewControllers[1]], direction: .reverse, animated: true, completion: nil)
  }
}

extension PageViewController: UIPageViewControllerDataSource {
  //获取前一个页面
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = allViewControllers.firstIndex(of: viewController) else {
      return nil
    }
        
    let previousIndex = viewControllerIndex - 1
    
    guard previousIndex >= 0 else {
      return nil
    }
    
    guard allViewControllers.count > previousIndex else {
      return nil
    }
    
    return allViewControllers[previousIndex]
  }
    
  //获取后一个页面
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = allViewControllers.firstIndex(of: viewController) else {
      return nil
    }
      
    let nextIndex = viewControllerIndex + 1
    let orderedViewControllersCount = allViewControllers.count
    
    guard orderedViewControllersCount != nextIndex else {
      return nil
    }
    
    guard orderedViewControllersCount > nextIndex else {
      return nil
    }
    
    return allViewControllers[nextIndex]
  }
}
