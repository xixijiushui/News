//
//  WendaAnswerBottomView.swift
//  News
//
//  Created by 赵伟 on 2018/12/24.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class WendaAnswerBottomView: UIView {

    let buttonWidth = screenWidth * 0.3
    
    let currentTheme = UserDefaults.standard.bool(forKey: isNight)
    
    var modules = [WendaModule]() {
        didSet {
            for (index, module) in modules.enumerated() {
                let button = BottomButton(frame: CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: 40))
                button.setTitle(module.text, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.theme_setTitleColor("colors.black", forState: .normal)
                button.kf.setImage(with: URL(string: currentTheme ? module.night_icon_url : module.day_icon_url), for: .normal)
                addSubview(button)
            }
        }
    }

}
