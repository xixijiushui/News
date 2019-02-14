//
//  BottomButton.swift
//  News
//
//  Created by 赵伟 on 2018/12/24.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class BottomButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 15, y: 9, width: 22, height: 22)
    }
}
