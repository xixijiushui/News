//
//  RelationRecommendView.swift
//  News
//
//  Created by 赵伟 on 2018/12/11.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class RelationRecommendView: UIView, NibLoadable {

    var userCards = [UserCard]()
    
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        theme_backgroundColor = "colors.tableViewBackgroundColor"
        collectionView.collectionViewLayout = RelationRecommendFlowLayout()
        collectionView.zw_registerCell(cell: RelationRecommendCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension RelationRecommendView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zw_dequeueReusableCell(indexPath: indexPath) as RelationRecommendCell
        cell.userCard = userCards[indexPath.item]
        return cell
    }
    
    
}

class RelationRecommendFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        itemSize = CGSize(width: 142, height: 190)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
