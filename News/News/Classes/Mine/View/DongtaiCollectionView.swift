//
//  DongtaiCollectionView.swift
//  News
//
//  Created by 赵伟 on 2018/12/14.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class DongtaiCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, NibLoadable {
    
    /// 是否发布了小视频
    var isPostSmallVideo = false
    /// 是否是动态详情
    var isDongtaiDetail = false
    
    var thumbImageList = [ThumbImageList]() {
        didSet {
            reloadData()
        }
    }
    
    var largerImageList = [LargeImageList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
        backgroundColor = .clear
        zw_registerCell(cell: DongtailCollectionViewCell.self)
        collectionViewLayout = DongtaiCollectionViewFlowLayout()
        isScrollEnabled = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zw_dequeueReusableCell(indexPath: indexPath) as DongtailCollectionViewCell
        cell.thumbImage = thumbImageList[indexPath.item]
        cell.isPostSmallVideo = isPostSmallVideo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if isPostSmallVideo {
            return
        }
        let previewBigImageVC = PreviewDongtaiBigImageController()
        previewBigImageVC.images = largerImageList
        previewBigImageVC.selectedIndex = indexPath.item
        UIApplication.shared.keyWindow?.rootViewController?.present(previewBigImageVC, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isDongtaiDetail ? Calculate.detailCollectionViewCellSize(thumbImageList) : Calculate.collectionViewCellSize(thumbImageList.count)
    }
}

class DongtaiCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }
}
