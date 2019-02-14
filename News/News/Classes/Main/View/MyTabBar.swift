//
//  MyTabBar.swift
//  News
//
//  Created by 赵伟 on 2018/12/6.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class MyTabBar: UITabBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        theme_tintColor = "colors.tabbarTintColor"
        theme_barTintColor = "colors.cellBackgroundColor"
        addSubview(publishButtom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // private 绝对私有, 除了在当前类中可以访问, 其他任何类或该类的扩展都不能访问到
    // fileprivate 文件私有, 可以在当前类文件中访问, 其他文件不能访问
    // open 在任何类文件中都能访问
    // internal 默认, 也可以不写
    private lazy var publishButtom: UIButton = {
        let publishhButton = UIButton(type: .custom)
        publishhButton.theme_setBackgroundImage("images.publishButtonBackgroundImage", forState: .normal)
        publishhButton.theme_setBackgroundImage("images.publishButtonBackgroundSelectedImage", forState: .selected)
        publishhButton.sizeToFit()
        return publishhButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.width
        let height: CGFloat = 49
        
        publishButtom.center = CGPoint(x: width * 0.5, y: height * 0.5 - 7)
        
        let buttonW: CGFloat = width * 0.2
        let buttonH: CGFloat = height
        let buttonY: CGFloat = 0
        
        var index = 0
        
        for button in subviews {
            if !button.isKind(of: NSClassFromString("UITabBarButton")!) {
                continue
            }
            let buttonX = buttonW * (index > 1 ? CGFloat(index + 1) : CGFloat(index))
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            index += 1
        }
    }
}
