//
//  HuoshanCategoryController.swift
//  News
//
//  Created by 赵伟 on 2018/12/25.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SVProgressHUD

class HuoshanCategoryController: UIViewController {

    /// 标题
    var newsTitle = HomeNewsTitle()
    
    /// collectionView
    @IBOutlet weak var collectionView: UICollectionView!
    /// 刷新时间
    var maxBehotTime: TimeInterval = 0.0
    /// 视频数据
    var smallVideos = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.configuration()
        collectionView.collectionViewLayout = HuoShanLayout()
        collectionView.zw_registerCell(cell: HuoshanCell.self)
        // 添加刷新控件
        setRefresh()
    }
    
    /// 添加刷新控件
    private func setRefresh() {
        // 下拉刷新
        let header = RefreshHeader { [weak self] in
            // 获取首页、视频、小视频的新闻列表数据
            NetworkTool.loadApiNewsFeeds(category: self!.newsTitle.category, ttFrom: .enterAuto, { (behotTime, newsModels) in
                if self!.collectionView.mj_header.isRefreshing {
                    self!.collectionView.mj_header.endRefreshing()
                }
                self!.maxBehotTime = behotTime
                self!.smallVideos = newsModels
                self!.collectionView.reloadData()
            })
        }
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isHidden = true
        collectionView.mj_header = header
        header?.beginRefreshing()
        // 上拉加载更多
        collectionView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
            NetworkTool.loadMoreApiNewsFeeds(category: self!.newsTitle.category, ttFrom: .enterAuto, maxBehotTime: self!.maxBehotTime, listCount: self!.smallVideos.count, { (newsModels) in
                if self!.collectionView.mj_footer.isRefreshing {
                    self!.collectionView.mj_footer.endRefreshing()
                }
                self!.collectionView.mj_footer.pullingPercent = 0.0
                if newsModels.count == 0 {
                    self!.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦！")
                    return
                }
                self!.smallVideos += newsModels
                self!.collectionView.reloadData()
            })
        })
        collectionView.mj_footer.isAutomaticallyChangeAlpha = true
    }
}

extension HuoshanCategoryController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zw_dequeueReusableCell(indexPath: indexPath) as HuoshanCell
        cell.smallVideo = smallVideos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let smallVideoVC = SmallVideoViewController()
        smallVideoVC.originalIndex = indexPath.item
        smallVideoVC.smallVideos = smallVideos
        present(smallVideoVC, animated: false, completion: nil)
    }
    
}

class HuoShanLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        let itemWidth = (screenWidth - 2) * 0.5
        itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        scrollDirection = .vertical
        minimumLineSpacing = 1.0
        minimumInteritemSpacing = 1.0
    }
}
