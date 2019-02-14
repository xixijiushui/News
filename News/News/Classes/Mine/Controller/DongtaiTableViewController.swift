//
//  DongtaiTableViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/20.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SVProgressHUD

class DongtaiTableViewController: UITableViewController {

    /// 刷新的指示器
    var maxCursor = 0
    var wendaCursor = ""
    /// 点击了 用户名
    var didSelectHeaderUserID: ((_ uid: Int)->())?
    /// 点击了 话题
    var didSelectHeaderTopicID: ((_ cid: Int)->())?
    /// 当前的 toptab 的类型
    var currentTopTabType: TopTabType = .dongtai {
        didSet {
            switch currentTopTabType {
            // 如果已经显示过了，就不再刷新数据了
            case .dongtai:      // 动态
                if !isDongtaisShown {
                    isDongtaisShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: { (dongtais) in
                        self.dongtais += dongtais
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            case .article:      // 文章
                if !isArticlesShown {
                    isArticlesShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: { (dongtais) in
                        self.articles += dongtais
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            case .video:        // 视频
                if !isVideosShown {
                    isVideosShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: { (dongtais) in
                        self.videos += dongtais
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            case .wenda:        // 问答
                if !isWendasShown {
                    isWendasShown = true
                    tableView.zw_registerCell(cell: UserDetailWendaCell.self)
                    tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
                        // 获取用户详情的问答列表更多数据
                        NetworkTool.loadUserDetailLoadMoreWendaList(userId:  self!.userId, cursor: self!.wendaCursor, completionHandler: { (cursor, wendas) in
                            self!.wendaCursor = cursor
                            if self!.tableView.mj_footer.isRefreshing { self!.tableView.mj_footer.endRefreshing() }
                            self!.tableView.mj_footer.pullingPercent = 0.0
                            if wendas.count == 0 {
                                self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                                SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                                return
                            }
                            self!.wendas += wendas
                            self!.tableView.reloadData()
                        })
                    })
                }
                tableView.mj_footer.beginRefreshing()
            case .iesVideo:     // 小视频
                if !isIesVideosShown {
                    isIesVideosShown = true
                    // 设置 footer
                    setupFooter(tableView, completionHandler: { (dongtais) in
                        self.iesVideos += dongtais
                        self.tableView.reloadData()
                    })
                    tableView.mj_footer.beginRefreshing()
                }
            }
        }
    }
    
    /// 用户编号
    var userId = 0
    
    /// 动态数据 数组
    var dongtais = [UserDetailDongtai]()
    var articles = [UserDetailDongtai]()
    var videos = [UserDetailDongtai]()
    var wendas = [UserDetailWenda]()
    var iesVideos = [UserDetailDongtai]()
    /// 记录当前的数据是否刷新过
    var isDongtaisShown = false
    var isArticlesShown = false
    var isVideosShown = false
    var isWendasShown = false
    var isIesVideosShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.configuration()
        if isIPhoneX { tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0) }
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.bouncesZoom = false
        if currentTopTabType == .wenda { tableView.zw_registerCell(cell: UserDetailWendaCell.self) }
        else { tableView.zw_registerCell(cell: UserDetailDongTaiCell.self) }
    }
    
    /// 设置 footer
    private func setupFooter(_ tableView: UITableView, completionHandler:@escaping ((_ datas: [UserDetailDongtai])->())) {
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
            NetworkTool.loadUserDetailDongtaiList(userId: self!.userId, maxCursor: self!.maxCursor, completionHandler: { (cursor, dongtais) in
                if tableView.mj_footer.isRefreshing { tableView.mj_footer.endRefreshing() }
                tableView.mj_footer.pullingPercent = 0.0
                if dongtais.count == 0 {
                    tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                    return
                }
                self!.maxCursor = cursor
                completionHandler(dongtais)
            })
        })
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return dongtais.count
        case .article:   // 文章
            return articles.count
        case .video:     // 视频
            return videos.count
        case .wenda:     // 问答
            return wendas.count
        case .iesVideo:  // 小视频
            return iesVideos.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return cellFor(tableView, at: indexPath, with: dongtais)
        case .article:   // 文章
            return cellFor(tableView, at: indexPath, with: articles)
        case .video:     // 视频
            return cellFor(tableView, at: indexPath, with: videos)
        case .wenda:     // 问答
            let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as UserDetailWendaCell
            cell.wenda = wendas[indexPath.row]
            return cell
        case .iesVideo:  // 小视频
            return cellFor(tableView, at: indexPath, with: iesVideos)
        }
    }
    
    /// 设置 cell
    private func cellFor(_ tableView: UITableView, at indexPath: IndexPath, with datas: [UserDetailDongtai]) -> UserDetailDongTaiCell {
        let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as UserDetailDongTaiCell
        cell.dongtai = datas[indexPath.row]
        cell.didSelectDongtaiUserName = { [weak self] (uid) in
            self!.didSelectHeaderUserID?(uid)
        }
        cell.didSelectDongtaiTopic = { [weak self] (cid) in
            self!.didSelectHeaderTopicID?(cid)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentTopTabType {
        case .dongtai:   // 动态
            return dongtais[indexPath.row].cellHeight!
        case .article:   // 文章
            return articles[indexPath.row].cellHeight!
        case .video:     // 视频
            return videos[indexPath.row].cellHeight!
        case .wenda:     // 问答
            let wenda = wendas[indexPath.row]
            return wenda.cellHeight!
        case .iesVideo:  // 小视频
            return iesVideos[indexPath.row].cellHeight!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch currentTopTabType {
        case .dongtai:    // 动态
            pushNextViewController(dongtais[indexPath.row])
        case .article:    // 文章
            pushNextViewController(articles[indexPath.row])
        case .video:     // 视频
            pushNextViewController(videos[indexPath.row])
        case .iesVideo:  // 小视频
            pushNextViewController(iesVideos[indexPath.row])
        case .wenda:     // 问答
            SVProgressHUD.showInfo(withStatus: "sslocal 参数未知，无法获取数据！")
        }
    }
    
    /// 跳转到下一个控制器
    private func pushNextViewController(_ dongtai: UserDetailDongtai) {
        switch dongtai.item_type {
        case .commentOrQuoteOthers, .commentOrQuoteContent, .forwardArticle, .postContent:
            let dongtaiDetailVC = DongtaiDetailViewController()
            dongtaiDetailVC.dongtai = dongtai
            navigationController?.pushViewController(dongtaiDetailVC, animated: true)
        case .postVideo, .postVideoOrArticle, .postContentAndVideo:
            SVProgressHUD.showInfo(withStatus: "跳转到视频控制器")
        case .proposeQuestion:
            let wendaVC = WendaViewController()
            wendaVC.qid = dongtai.id
            wendaVC.enterForm = .dongtai
            navigationController?.pushViewController(wendaVC, animated: true)
        case .answerQuestion:
            SVProgressHUD.showInfo(withStatus: "sslocal 参数未知，无法获取数据！")
        case .postSmallVideo:
            SVProgressHUD.showInfo(withStatus: "请点击底部小视频 tabbar")
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 { tableView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}
