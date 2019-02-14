//
//  UserDiggCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable

class UserDiggCell: UITableViewCell, RegisterCellOrNib {

    var user = DongtaiUserDigg() {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: user.avatar_url)!)
            vImageView.isHidden = !user.user_verified
            nameLabel.text = user.screen_name
            vertifiedConyentLabel.text = user.verified_reason
        }
    }
    
    /// 头像
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    /// v图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 认证内容
    @IBOutlet weak var vertifiedConyentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
