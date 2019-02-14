//
//  UserDetailCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/20.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell, RegisterCellOrNib {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
