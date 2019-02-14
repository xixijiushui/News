//
//  DongtaiNavigationBar.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiNavigationBar: UIView, NibLoadable {

    var user = DongtaiUser() {
        didSet {
            avatarButton.kf.setImage(with: URL(string: user.avatar_url)!, for: .normal)
            nameButton.setTitle(user.screen_name, for: .normal)
            followersButton.setTitle(user.followersCount! + "粉丝", for: .normal)
        }
    }
    
    @IBOutlet weak var avatarButton: AnimatableButton!
    
    @IBOutlet weak var vImageView: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameButton.theme_setTitleColor("colors.black", forState: .normal)
        followersButton.theme_setTitleColor("colors.black", forState: .normal)
    }
    
    /// 固有的大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    @IBAction func buttonClicked() {
        
    }
}
