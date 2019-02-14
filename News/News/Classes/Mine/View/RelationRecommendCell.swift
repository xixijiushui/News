//
//  RelationRecommendCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/11.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class RelationRecommendCell: UICollectionViewCell, RegisterCellOrNib {

    var userCard: UserCard? {
        didSet {
            nameLabel.text = userCard!.user.info.name
            avatarImageView.kf.setImage(with: URL(string: userCard!.user.info.avatar_url))
            vImageView.isHidden = (userCard!.user.info.user_auth_info == "") ? true : false
            recommendReasonLabel.text = userCard!.recommend_reason
        }
    }
    
    private lazy var animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.ratation.z")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 1.5
        animation.autoreverses = false
        animation.repeatCount = MAXFLOAT
        return animation
    }()
    
    /// 头像
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    /// V 图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名称
    @IBOutlet weak var nameLabel: UILabel!
    /// 推荐原因
    @IBOutlet weak var recommendReasonLabel: UILabel!
    /// 加载图标
    @IBOutlet weak var loadingImageView: UIImageView!
    /// 关注按钮
    @IBOutlet weak var concernButton: AnimatableButton!
    /// 底层view
    @IBOutlet weak var baseView: AnimatableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        theme_backgroundColor = "colors.cellBackgroundColor"
        nameLabel.theme_textColor = "colors.black"
        recommendReasonLabel.theme_textColor = "colors.black"
        baseView.theme_backgroundColor = "colors.cellBackgroundColor"
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
    }

    /// 关注按钮点击
    @IBAction func concernButtonClicked(_ sender: AnimatableButton) {
        loadingImageView.isHidden = false
        loadingImageView.layer.add(animation, forKey: nil)
        if sender.isSelected {
            // 已关注, 取消关注
            NetworkTool.loadRelationUnfollow(userId: userCard!.user.info.user_id, completionHandler: { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.globalRedColor"
                self.loadingImageView.layer.removeAllAnimations()
                self.loadingImageView.isHidden = true
                self.concernButton.borderWidth = 0
                })
        } else {
            // 未关注, 关注
            NetworkTool.loadRelationFollow(userId: userCard!.user.info.user_id, completionHandler: { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                self.loadingImageView.layer.removeAllAnimations()
                self.loadingImageView.isHidden = true
                self.concernButton.borderColor = UIColor.grayColor232()
                self.concernButton.borderWidth = 1
            })
        }
    }
}
