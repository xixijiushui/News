//
//  MyTabBarController.swift
//  News
//
//  Created by 赵伟 on 2018/12/6.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = UITabBar.appearance()
        tabbar.tintColor = UIColor(r: 245, g: 90, b: 93)
        
        zw_addChildViewControllers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonCliked), name: NSNotification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
    }
    
    // 接收到切换主题的通知
    @objc func receiveDayOrNightButtonCliked(notification: Notification) {
        let selected = notification.object as! Bool
        // selected为true则为夜间模式
        if selected {
            for childController in children {
                switch childController.tabBarItem.title! {
                case "首页":
                    setNightChildController(controller: childController, imageName: "home")
                case "视频":
                    setNightChildController(controller: childController, imageName: "video")
                case "小视频":
                    setNightChildController(controller: childController, imageName: "huoshan")
                case "未登录":
                    setNightChildController(controller: childController, imageName: "no_login")
                default:
                    break
                }
            }
        } else {
            for childController in children {
                switch childController.tabBarItem.title! {
                case "首页":
                    setDayChildController(controller: childController, imageName: "home")
                case "视频":
                    setDayChildController(controller: childController, imageName: "video")
                case "小视频":
                    setDayChildController(controller: childController, imageName: "huoshan")
                case "微头条":
                    setDayChildController(controller: childController, imageName: "weitoutiao")
                default:
                    break
                }
            }
        }
    }

    // 设置夜间控制器
    private func setNightChildController(controller: UIViewController, imageName: String) {
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_night_32x32_")
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_tabbar_press_night_32x32_")
    }
    
    // 设置白天控制器
    private func setDayChildController(controller: UIViewController, imageName: String) {
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_32x32_")
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_tabbar_press_32x32_")
    }
    
    private func zw_addChildViewControllers() {
        zw_setChildViewController(childController: HomeViewController(), imageName: "home", title: "首页")
        zw_setChildViewController(childController: VideoViewController(), imageName: "video", title: "视频")
        zw_setChildViewController(childController: WeitoutiaoViewController(), imageName: "weitoutiao", title: "微头条")
        zw_setChildViewController(childController: HuoShanViewController(), imageName: "huoshan", title: "小视频")
        
        // tabbar 是 readonly 属性,不能直接修改, 使用KVC
        setValue(MyTabBar(), forKey: "tabBar")
    }
    
    private func zw_setChildViewController(childController: UIViewController, imageName: String, title: String) {
        if UserDefaults.standard.bool(forKey: isNight) {
            setNightChildController(controller: childController, imageName: imageName)
        } else {
            setDayChildController(controller: childController, imageName: imageName)
        }
        // 设置 tabbar 文字和图片
        childController.tabBarItem.title = title
        childController.navigationItem.title = title
        
        // 添加导航控制器
        let navVC = MyNavigationController(rootViewController: childController)
        addChild(navVC)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
