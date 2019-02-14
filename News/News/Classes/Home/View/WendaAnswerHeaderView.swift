//
//  WendaAnswerHeaderView.swift
//  News
//
//  Created by 赵伟 on 2018/12/24.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class WendaAnswerHeaderView: UIView, NibLoadable {

    var question = WendaQuestion() {
        didSet {
            titleLabel.text = question.title
            titleLabelHeight.constant = question.titleH!
            contentLabel.text = question.content.text
            answerCountLabel.text = question.answerCount! + "个问答 · "
            collectionCountLabel.text = question.answerCount! + "人收藏"
            // 如果有图
            if question.content.thumb_image_list.count != 0 {
                let thumb = question.content.thumb_image_list.first!
                imageView.kf.setImage(with: URL(string: thumb.url)!)
                imageViewHeight.constant = 166.0
                imageViewWidth.constant = 166 * thumb.ratio!
            }
            height = question.foldHeight!
            layoutIfNeeded()
        }
    }
    
    /// 点击了展开按钮
    var didSelectUnfoldButton: (() -> ())?
    
    /// 收藏按钮
    @IBOutlet weak var collectButton: UIButton!
    /// 邀请回答按钮
    @IBOutlet weak var inviteButton: UIButton!
    /// 分割线
    @IBOutlet weak var separatorView: UIView!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    /// 展开按钮
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var unfoldButtonWidth: NSLayoutConstraint!
    /// 回答数量
    @IBOutlet weak var answerCountLabel: UILabel!
    /// 收藏数量
    @IBOutlet weak var collectionCountLabel: UILabel!
    /// 图片
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        width = screenWidth
        theme_backgroundColor = "colors.cellBackgroundColor"
        titleLabel.theme_textColor = "colors.black"
        contentLabel.theme_textColor = "colors.lightGray"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        collectButton.theme_setTitleColor("colors.userDetailSendMailTextColor", forState: .normal)
        inviteButton.theme_setTitleColor("colors.userDetailSendMailTextColor", forState: .normal)
        unfoldButton.theme_setTitleColor("colors.userDetailSendMailTextColor", forState: .normal)
    }

    @IBAction func unfoldButtonClicked(_ sender: UIButton) {
        sender.isHidden = true
        unfoldButtonWidth.constant = 0
        contentLabelHeight.constant = question.content.textH!
        height = question.unfoldHeight!
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.didSelectUnfoldButton?()
        }
    }
}
