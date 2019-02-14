//
//  RealVideo.swift
//  News
//
//  Created by 赵伟 on 2018/12/25.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import HandyJSON

struct RealVideo: HandyJSON {
    
    var status: Int = 0
    var user_id: String = ""
    var video_id: String = ""
    var validate: Int = 0
    var enable_ssl: Bool = false
    var video_duration: Float = 0.0
    var video_list = VideoList()
}
