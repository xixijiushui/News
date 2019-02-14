//
//  PopoverAnimator.swift
//  News
//
//  Created by 赵伟 on 2018/12/12.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    /// 展现的视图大小
    var presentFrame: CGRect?
    /// 记录当前是否打开
    var isPresent: Bool = false
    
    ///
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = MyPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    
    /// 展开关闭
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            // 展开
            let toView = transitionContext.view(forKey: .to)
            toView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            transitionContext.containerView.addSubview(toView!)
            // 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView?.transform = .identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        } else {
            // 关闭
            // 拿到关闭的视图
            let fromView = transitionContext.view(forKey: .from)
            // 执行动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromView?.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    /// 实现此方法,系统默认动画就消失了,所有设置需要我们自己实现
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    /// 告诉系统谁来负责 Modal 的消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    /// 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
}
