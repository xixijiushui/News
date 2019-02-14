//
//  MyPresentationController.swift
//  News
//
//  Created by 赵伟 on 2018/12/12.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class MyPresentationController: UIPresentationController {
    
    var presentFrame: CGRect?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPresentedViewController), name: Notification.Name(rawValue: MyPresentationControllerDismiss), object: nil)
    }
    
    /// 即将布局转场子视图调用
    override func containerViewDidLayoutSubviews() {
        /// 修改弹出视图的大小
        presentedView?.frame = presentFrame!
        
        let coverView = UIView(frame: UIScreen.main.bounds)
        coverView.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPresentedViewController))
        coverView.addGestureRecognizer(tap)
        // 添加蒙版
        containerView?.insertSubview(coverView, at: 0)
    }
    
    /// 移除弹出的控制器
    @objc private func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: false, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
