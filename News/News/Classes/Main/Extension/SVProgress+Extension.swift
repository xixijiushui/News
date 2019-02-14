//
//  SVProgress+Extension.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import SVProgressHUD

extension SVProgressHUD {
    // 设置 SVProgressHUD 属性
    static func configuration() {
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setBackgroundColor(UIColor(r: 0, g: 0, b: 0, alpha: 0.3))
    }
}
