//
//  VideoViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/6.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    private lazy var navigationBar: HomeNavigationView = {
        let navigationBar = HomeNavigationView.loadViewFromNib()
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置 UI
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置状态栏属性
        navigationController?.navigationBar.barStyle = .black
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if UserDefaults.standard.bool(forKey: isNight) {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
    }
}

// MARK: - 导航栏按钮点击
extension VideoViewController {
    
    /// 设置 UI
    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        // 设置自定义导航栏
        navigationItem.titleView = navigationBar
        // 搜索按钮点击
        navigationBar.didSelectedSearchButton = {
            
        }
        // 头像按钮点击
        navigationBar.didSelectedAvatarButton = { [weak self] in
            self!.navigationController?.pushViewController(MineViewController(), animated: true)
        }
    }
}
