//
//  DongtaiCommentCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable

class DongtaiCommentCell: UITableViewCell, RegisterCellOrNib {

    var comment = DongtaiComment() {
        didSet {
            vImageView.isHidden = !comment.user_verified
            nameLabel.text = comment.user_name != "" ? comment.user_name : ""
            if comment.user_auth_info != "" {
                authInfoLabel.text = comment.userAuthInfo!.auth_info
            }
            if comment.user_profile_image_url != "" {
                avatarButton.kf.setImage(with: URL(string: comment.user_profile_image_url)!, for: .normal)
            } else if comment.avatar_url != "" {
                avatarButton.kf.setImage(with: URL(string: comment.avatar_url)!, for: .normal)
            } else if comment.user.user_id != 0 {
                avatarButton.kf.setImage(with: URL(string: comment.user.avatar_url)!, for: .normal)
                nameLabel.text = comment.user.screen_name
                vImageView.isHidden = !comment.user.user_verified
                if comment.user.user_auth_info != "" {
                    authInfoLabel.text = comment.user.userAuthInfo!.auth_info
                }
            }
            contentLabel.attributedText = comment.attributedContent!
            timeLabel.text = comment.createTime!
            replyButton.setTitle(comment.reply_count == 0 ? "回复" : "\(comment.reply_count)回复", for: .normal)
            diggButton.isSelected = comment.user_digg
        }
    }
    
    /// 头像
    @IBOutlet weak var avatarButton: AnimatableButton!
    /// v 图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 认证内容
    @IBOutlet weak var authInfoLabel: UILabel!
    /// 点赞按钮
    @IBOutlet weak var diggButton: UIButton!
    /// 内容
    @IBOutlet weak var contentLabel: RichLabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 回复按钮
    @IBOutlet weak var replyButton: AnimatableButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        diggButton.theme_setImage("images.comment_like_icon_16x16_", forState: .normal)
        diggButton.theme_setImage("images.comment_like_icon_press_16x16_", forState: .selected)
        contentLabel.theme_textColor = "colors.black"
        diggButton.theme_setTitleColor("colors.grayColor150", forState: .normal)
        authInfoLabel.theme_textColor = "colors.grayColor150"
        timeLabel.theme_textColor = "colors.grayColor150"
        replyButton.theme_setTitleColor("colors.grayColor150", forState: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 点赞按钮点击
    @IBAction func diggButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 回复按钮点击
    @IBAction func replyButtonClicked(_ sender: AnimatableButton) {
    }
}
