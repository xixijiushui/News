//
//  EmojiCollectionCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/20.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class EmojiCollectionCell: UICollectionViewCell, RegisterCellOrNib {
    
    var emoji = Emoji() {
        didSet {
            if emoji.isDelete {
                iconButton.theme_setImage("images.input_emoji_delete_44x44_", forState: .normal)
            } else if emoji.isEmpty {
                iconButton.setImage(nil, for: .normal)
            } else {
                iconButton.setImage(UIImage(named: emoji.png), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        theme_backgroundColor = "colors.cellBackgroundColor"
    }

}
