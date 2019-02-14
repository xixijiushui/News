//
//  HuoShanViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/6.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SGPagingView

class HuoShanViewController: UIViewController {

    /// 懒加载 导航栏
    private lazy var navigationBar = HuoShanNavigationBar()
    
    var pageContentView: SGPageContentScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension HuoShanViewController {
    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationItem.titleView = navigationBar
        // 判断是否是夜间
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: NSNotification.Name("dayOrNightButtonClicked"), object: nil)
        // 小视频导航看标题的数据
        NetworkTool.loadSmallVideoCategories { (homeNewsTitles) in
            self.navigationBar.titleNames = homeNewsTitles.compactMap({ $0.name })
            // 设置子控制器
            var childVCs = [HuoshanCategoryController]()
            for homeNewsTitle in homeNewsTitles {
                let categoryVC = HuoshanCategoryController()
                categoryVC.newsTitle = homeNewsTitle
                childVCs.append(categoryVC)
            }
//            let childVCs = homeNewsTitles.compactMap({ (newsTitle) -> () in
//                let categoryVC = HuoshanCategoryController()
//                categoryVC.newsTitle = newsTitle
//                return categoryVC
//            })
            self.pageContentView = SGPageContentScrollView(frame: self.view.bounds, parentVC: self, childVCs: childVCs)
            self.pageContentView!.delegatePageContentScrollView = self
            self.view.addSubview(self.pageContentView!)
        }
        
        // 点击了标题
        navigationBar.pageTitleViewSelected = { [weak self] (index) in
            self!.pageContentView!.setPageContentScrollViewCurrentIndex(index)
        }
    }
    
    @objc private func receiveDayOrNightButtonClicked(notification: NSNotification) {
        // 判断是否是夜间
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
    }
}

extension HuoShanViewController: SGPageContentScrollViewDelegate {
    
    /// 联动 SGPageTitleView 的方法
    func pageContentScrollView(_ pageContentScrollView: SGPageContentScrollView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        self.navigationBar.pageTitleView!.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
