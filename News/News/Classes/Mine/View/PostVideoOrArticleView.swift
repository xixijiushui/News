//
//  PostVideoOrArticleView.swift
//  News
//
//  Created by 赵伟 on 2018/12/14.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import Kingfisher

class PostVideoOrArticleView: UIView, NibLoadable {

    var group = DongtaiOriginGroup() {
        didSet {
            titleLabel.text = " " + group.title
            if group.thumb_url != "" {
                iconButton.kf.setBackgroundImage(with: URL(string: group.thumb_url)!, for: .normal)
            } else if group.user.avatar_url != "" {
                iconButton.kf.setBackgroundImage(with: URL(string: group.user.avatar_url)!, for: .normal)
            } else if group.show_tips == "原内容已删除" {
                titleLabel.text = group.show_tips
                titleLabel.textAlignment = .center
                iconBuuttonWidth.constant = 0
                layoutIfNeeded()
            }
            switch group.media_type {
            case .postArticle:
                iconButton.setImage(nil, for: .normal)
            case .postVideo:
                iconButton.theme_setImage("images.smallvideo_all_32x32_", forState: .normal)
            }
        }
    }
    
    /// 图标
    @IBOutlet weak var iconButton: UIButton!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 图标宽度
    @IBOutlet weak var iconBuuttonWidth: NSLayoutConstraint!
    
    /// 覆盖按钮点击
    @IBAction func coverButtonClicked(_ sender: UIButton) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleLabel.theme_textColor = "colors.black"
        titleLabel.theme_backgroundColor = "colors.grayColor247"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        width = screenWidth - 30
    }
}
