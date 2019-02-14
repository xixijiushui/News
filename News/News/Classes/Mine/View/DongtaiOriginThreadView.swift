//
//  DongtaiOriginThreadView.swift
//  News
//
//  Created by 赵伟 on 2018/12/14.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class DongtaiOriginThreadView: UIView, NibLoadable {

    var emojiManager = EmojiManager()
    
    var isPosrtSmallVideo = false
    
    var originthread = DongtaiOriginThread() {
        didSet {
            contentLabelHeight.constant = originthread.contentH!
            contentLabel.attributedText = originthread.attributedContent
            collectionView.isDongtaiDetail = originthread.isDongtaiDetail
            collectionView.thumbImageList = originthread.thumb_image_list
            collectionView.largerImageList = originthread.large_image_list
            collectionViewWidth.constant = originthread.collectionViewW!
            layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: DongtaiCollectionView!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        theme_backgroundColor = "colors.grayColor247"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        height = originthread.height!
        width = screenWidth
    }
}
