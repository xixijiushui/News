//
//  SmallVideoCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/25.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable

class SmallVideoCell: UICollectionViewCell, RegisterCellOrNib {

    var didSelectAvatarOrNameButton: (() -> ())?
    
    var smallVideo = NewsModel() {
        didSet {
            bgImageView.image = nil
            nameButton.setTitle(smallVideo.raw_data.user.info.name, for: .normal)
            avatarButton.kf.setImage(with: URL(string: smallVideo.raw_data.user.info.avatar_url), for: .normal)
            vImageview.isHidden = !smallVideo.raw_data.user.info.user_verified
            concernButton.isSelected = smallVideo.raw_data.user.relation.is_following
            titleLabel.attributedText = smallVideo.raw_data.attrbutedText!
        }
    }
    
    /// 头像按钮
    @IBOutlet weak var avatarButton: AnimatableButton!
    /// v 图标
    @IBOutlet weak var vImageview: UIImageView!
    /// 名字按钮
    @IBOutlet weak var nameButton: AnimatableButton!
    /// 关注按钮
    @IBOutlet weak var concernButton: AnimatableButton!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollLabel: UILabel!
    /// 背景图
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    /// 关注按钮点击
    @IBAction func concernButtonClicked(_ sender: AnimatableButton) {
        if sender.isSelected { // 已关注,则取消关注
            NetworkTool.loadRelationUnfollow(userId: smallVideo.raw_data.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.globalRedColor"
            }
        } else { // 未关注,则关注
            NetworkTool.loadRelationFollow(userId: smallVideo.raw_data.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
            }
        }
    }
    
    /// 头像按钮或用户名按钮点击
    @IBAction func avatarButtonClicked(_ sender: AnimatableButton) {
        didSelectAvatarOrNameButton?()
    }
}
