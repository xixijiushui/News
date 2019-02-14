//
//  EmojiLayout.swift
//  News
//
//  Created by 赵伟 on 2018/12/20.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class EmojiLayout: UICollectionViewFlowLayout {
    
    /// 一行多少个
    private var columns = 7
    /// 多少行
    private var rows = 3
    /// 保存所有的item
    private var attributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        // item大小
        itemSize = CGSize(width: emojiItemWidth, height: emojiItemWidth)
        // 设置间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // 设置水平滑动
        scrollDirection = .horizontal
        // 设置collectionv相关属性
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        let margin = (collectionView!.height - 3 * emojiItemWidth) * 0.5
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
        var page = 0
        // item的个数
        let items = collectionView?.numberOfItems(inSection: 0)
        // 遍历
        for item in 0..<items! {
            let indexPath = IndexPath(item: item, section: 0)
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            page = item / (columns * rows)
            // 通过计算得到x, y
            let x = itemSize.width * CGFloat(item % columns) + (CGFloat(page) * screenWidth)
            let y = itemSize.height * CGFloat((item - page * rows * columns) / columns)
            layoutAttributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来存到数组中
            attributes.append(layoutAttributes)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return super.collectionViewContentSize
    }
    
    /// 每一个元素的布局属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter({
            rect.contains($0.frame)
        })
    }
}

