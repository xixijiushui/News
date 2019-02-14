//
//  WeitoutiaoViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/17.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class WeitoutiaoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension WeitoutiaoViewController {
    
    /// 设置UI
    func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        
        // 判断是否是夜间
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        // 添加导航和右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        // 添加通知
            NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: NSNotification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
    }
    
    /// 接受了按钮点击的通知
    @objc private func receiveDayOrNightButtonClicked(notification: Notification) {
//        let selected = notification.object as! Bool
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
    }
    
    /// 右侧按钮点击
    @objc private func rightBarButtonItemClicked() {
        
    }
}
