//
//  SmallVideoLayout.swift
//  News
//
//  Created by 赵伟 on 2018/12/25.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class SmallVideoLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        itemSize = CGSize(width: collectionView!.width, height: collectionView!.height)
//        itemSize = CGSize(width: screenWidth, height: screenHeight - (isIPhoneX ? 136 : 60))
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
    }
    
}
