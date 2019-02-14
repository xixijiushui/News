//
//  OfflineDownloadCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/10.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class OfflineDownloadCell: UITableViewCell, RegisterCellOrNib {
    // 标题
    @IBOutlet weak var titleLabel: UILabel!
    // 勾选图片
    @IBOutlet weak var rightImageView: UIImageView!
    
    var homeNewsTitle: HomeNewsTitle? {
        didSet {
            titleLabel.text = homeNewsTitle!.name
            rightImageView.theme_image = homeNewsTitle!.selected ? "images.air_download_option_press" : "images.air_download_option"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
