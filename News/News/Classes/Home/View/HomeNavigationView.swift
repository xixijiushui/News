//
//  HomeNavigationView.swift
//  News
//
//  Created by 赵伟 on 2018/12/14.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable

class HomeNavigationView: UIView, NibLoadable {

    @IBOutlet weak var avatarButton: AnimatableButton!
    
    @IBOutlet weak var searchButton: AnimatableButton!
    
    /// 搜索按钮点击
    var didSelectedSearchButton: (() -> ())?
    /// 头像按钮点击
    var didSelectedAvatarButton: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchButton.contentHorizontalAlignment = .left
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        searchButton.titleLabel?.lineBreakMode = .byTruncatingTail
        searchButton.theme_backgroundColor = "colors.cellBackgroundColor"
        searchButton.theme_setTitleColor("colors.grayColor150", forState: .normal)
        searchButton.setImage(UIImage(named: "search_small_16x16_"), for: [.normal, .highlighted])
        avatarButton.theme_setImage("images.home_no_login_head", forState: .normal)
        avatarButton.theme_setImage("images.home_no_login_head", forState: .highlighted)
        // 首页顶部导航栏搜索推荐标题内容
        NetworkTool.loadHomeSearchSuggestInfo { (suggest) in
            self.searchButton.setTitle(suggest, for: .normal)
        }
    }
    
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
    
    @IBAction func avatarButtonClicked(_ sender: AnimatableButton) {
        didSelectedAvatarButton?()
    }
    
    @IBAction func searchButtonClicked(_ sender: AnimatableButton) {
        didSelectedSearchButton?()
    }
    
}
