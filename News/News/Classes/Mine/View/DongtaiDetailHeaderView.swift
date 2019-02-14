//
//  DongtaiDetailHeaderView.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiDetailHeaderView: UIView, NibLoadable {

    /// 点击了 点赞按钮
    var didSelectDiggButton: ((_ dongtai: UserDetailDongtai) -> ())?
    /// 点击了 用户名
    var didSelectDongtaiUserName: ((_ uid: Int) -> ())?
    /// 点击了 话题
    var didSelectDongtaiTopic: ((_ cid: Int) -> ())?
    /// 点击了覆盖的按钮
    var didSelectCoverButton: ((_ userId: Int) -> ())?
    
    var dongtai = UserDetailDongtai() {
        didSet {
            theme_backgroundColor = "colors.cellBackgroundColor"
            avatarButton.kf.setImage(with: URL(string: dongtai.user.avatar_url), for: .normal)
            nameLabel.text = dongtai.user.screen_name
            timeLabel.text = "· " + dongtai.createTime!
            descriptionLabel.text = dongtai.user.verified_content
            readCountLabel.text = dongtai.readCount! + "阅读 ·" + dongtai.brand_info + " " + dongtai.position.position
            conmentCountLabel.text = dongtai.commentCount! + "评论"
            zanButton.setTitle(dongtai.diggCount!, for: .normal)
            // 显示emoji
            contentLabel.attributedText = dongtai.attributedContent!
            // 点击了用户
            contentLabel.userTapped = { [weak self] (userName, range) in
                self!.didSelectDongtaiUserName?(Int((self!.dongtai.userContents!.filter({
                    userName.contains($0.name)
                }).first?.uid)!)!)
            }
            // 点击了话题
            contentLabel.topicTapped = { [weak self] (topic, range) in
                self!.didSelectDongtaiUserName?(Int((self!.dongtai.topicContents!.filter({
                    topic.contains($0.name)
                }).first?.uid)!)!)
            }
            // 防止cell重用机制
            if #available(iOS 11.0, *) {
                if middleView.contains(postVideoOrArticleView) {
                    postVideoOrArticleView.removeFromSuperview()
                }
            } else {
                if middleView.subviews.contains(postVideoOrArticleView) {
                    postVideoOrArticleView.removeFromSuperview()
                }
            }
            if #available(iOS 11.0, *) {
                if middleView.contains(collectionView) {
                    collectionView.removeFromSuperview()
                }
            } else {
                if middleView.subviews.contains(collectionView) {
                    collectionView.removeFromSuperview()
                }
            }
            if #available(iOS 11.0, *) {
                if middleView.contains(originThreadView) {
                    originThreadView.removeFromSuperview()
                }
            } else {
                if middleView.subviews.contains(originThreadView) {
                    originThreadView.removeFromSuperview()
                }
            }
            
            switch dongtai.item_type {
            case .postVideoOrArticle, .postVideo, .answerQuestion, .proposeQuestion, .forwardArticle, .postContentAndVideo:
                middleView.addSubview(postVideoOrArticleView)
                postVideoOrArticleView.frame = CGRect(x: 15, y: 0, width: screenWidth - 30, height: middleView.height)
                postVideoOrArticleView.group = dongtai.group.title == "" ? dongtai.origin_group : dongtai.group
            case .postContent, .postSmallVideo:
                middleView.addSubview(collectionView)
                collectionView.isDongtaiDetail = true
                collectionView.frame = CGRect(x: 15, y: 0, width: dongtai.collectionViewW!, height: dongtai.collectionViewH!)
                collectionView.isPostSmallVideo = (dongtai.item_type == .postSmallVideo)
                collectionView.thumbImageList = dongtai.thumb_image_list
                collectionView.largerImageList = dongtai.large_image_list
            case .commentOrQuoteOthers, .commentOrQuoteContent:
                middleView.addSubview(originThreadView)
                originThreadView.originthread.isDongtaiDetail = true
                originThreadView.frame = CGRect(x: 0, y: 0, width: screenWidth - 30, height: dongtai.origin_thread.height!)
                originThreadView.originthread = dongtai.origin_thread
            }
        }
    }
    
    /// 头像
    @IBOutlet weak var avatarButton: AnimatableButton!
    /// v 图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 创建时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 描述
    @IBOutlet weak var descriptionLabel: UILabel!
    /// 分割view
    @IBOutlet weak var separatorView: UIView!
    /// 阅读数量
    @IBOutlet weak var readCountLabel: UILabel!
    /// 中间的view
    @IBOutlet weak var middleView: UIView!
    /// 内容
    @IBOutlet weak var contentLabel: RichLabel!
    /// 评论数量
    @IBOutlet weak var conmentCountLabel: UILabel!
    /// 赞按钮
    @IBOutlet weak var zanButton: UIButton!
    
    /// 懒加载 评论或引用
    private lazy var originThreadView: DongtaiOriginThreadView = {
        let originThreadView = DongtaiOriginThreadView.loadViewFromNib()
        return originThreadView
    }()
    
    /// 懒加载 发布文章或视频
    private lazy var postVideoOrArticleView: PostVideoOrArticleView = {
        let postVideoOrArticleView = PostVideoOrArticleView.loadViewFromNib()
        return postVideoOrArticleView
    }()
    
    /// 懒加载 collectionView
    private lazy var collectionView: DongtaiCollectionView = {
        let collectionView = DongtaiCollectionView.loadViewFromNib()
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        theme_backgroundColor = "colors.cellBackgroundColor"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        nameLabel.theme_textColor = "colors.black"
        timeLabel.theme_textColor = "colors.grayColor150"
        descriptionLabel.theme_textColor = "colors.grayColor150"
        readCountLabel.theme_textColor = "colors.grayColor150"
        contentLabel.theme_textColor = "colors.black"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = dongtai.detailHeaderHeight!
    }
    
    @IBAction func coverButtonClicked(_ sender: UIButton) {
        didSelectCoverButton?(dongtai.user.user_id)
    }
    
    @IBAction func diggButtonClicked(_ sender: UIButton) {
        didSelectDiggButton?(dongtai)
    }
}
