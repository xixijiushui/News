//
//  DongtailCollectionViewCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/14.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class DongtailCollectionViewCell: UICollectionViewCell, RegisterCellOrNib {

    var isPostSmallVideo: Bool = false {
        didSet {
            iconButton.theme_setImage(isPostSmallVideo ? "images.smallvideo_all_32x32_" : nil, forState: .normal)
        }
    }
    
    var thumbImage: ThumbImageList? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage!.url))
        }
    }
    
    var largeImage: LargeImageList? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: largeImage!.urlString!)!, placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                let progress = Float(receivedSize) / Float(totalSize)
                SVProgressHUD.showProgress(progress)
                SVProgressHUD.setBackgroundColor(.clear)
                SVProgressHUD.setForegroundColor(UIColor.white)
            }) { (image, error, cacheType, url) in
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var iconButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        thumbImageView.layer.theme_backgroundColor = "colors.grayColor230"
        thumbImageView.layer.borderWidth = 1
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

}
