//
//  HuoShanNavigationBar.swift
//  News
//
//  Created by 赵伟 on 2018/12/25.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SGPagingView

class HuoShanNavigationBar: UIView {

    /// 点击了标题
    var pageTitleViewSelected: ((_ index: Int) -> ())?
    
    var titleNames = [String]() {
        didSet {
            let configuration = SGPageTitleViewConfigure()
            configuration.titleColor = .black
            configuration.titleSelectedColor = .globalRedColor()
            configuration.indicatorColor = .clear
            pageTitleView = SGPageTitleView(frame: CGRect(x: -10, y: 0, width: screenWidth, height: 44), delegate: self, titleNames: titleNames, configure: configuration)
            pageTitleView!.backgroundColor = .clear
            addSubview(pageTitleView!)
        }
    }
    
    var pageTitleView: SGPageTitleView?

    /// 固有的大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    /// 重写frame
    override var frame: CGRect {
        didSet {
            super.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        }
    }
}

extension HuoShanNavigationBar: SGPageTitleViewDelegate {
    
    /// 联动 pageContent 方法
    func pageTitleView(_ pageTitleView: SGPageTitleView!, selectedIndex: Int) {
        pageTitleViewSelected!(selectedIndex)
    }
}
