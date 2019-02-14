//
//  MyConcernCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/7.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import Kingfisher

class MyConcernCell: UICollectionViewCell, RegisterCellOrNib {
    /// 头像
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var vipImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 新通知
    @IBOutlet weak var tipsButton: UIButton!
    
    var myConcern: MyConcern? {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: (myConcern?.icon)!))
            nameLabel.text = myConcern?.name
            if let isVertify = myConcern?.is_verify {
                vipImageView.isHidden = !isVertify
            }
            
            if let tips = myConcern?.tips {
                tipsButton.isHidden = !tips
            }
            
            if let userAuthInfo = myConcern?.userAuthInfo {
                vipImageView.image = userAuthInfo.auth_type == 1 ? UIImage(named: "all_v_avatar_star_16x16_") : UIImage(named: "all_v_avatar_18x18_")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tipsButton.layer.borderWidth = 1
        tipsButton.layer.borderColor = UIColor.white.cgColor
        
        theme_backgroundColor = "colors.cellBackgroundColor"
        nameLabel.theme_textColor = "colors.black"
    }

}
