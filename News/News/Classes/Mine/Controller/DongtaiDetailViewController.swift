//
//  DongtaiDetailViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable
import SVProgressHUD

class DongtaiDetailViewController: UIViewController {
    
    var dongtai = UserDetailDongtai() {
        didSet {
            navigationBar.user = dongtai.user
            headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dongtai.detailHeaderHeight!)
            headerView.dongtai = dongtai
        }
    }
    
    /// emoji 图标
    @IBOutlet weak var emojiButton: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    /// 点赞按钮
    @IBOutlet weak var diggButton: UIButton!
    /// 分享按钮
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentView: AnimatableView!
    
    private lazy var headerView: DongtaiDetailHeaderView = {
        let headerView = DongtaiDetailHeaderView.loadViewFromNib()
        return headerView
    }()
    
    private lazy var navigationBar: DongtaiNavigationBar = {
        let navigationBar = DongtaiNavigationBar.loadViewFromNib()
        return navigationBar
    }()
    
    var comments = [DongtaiComment]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI
        setupUI()
        // 点击事件
        selectedAction()
    }
}

// MARK: - UI
extension DongtaiDetailViewController {
    
    /// 设置UI
    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        commentView.theme_backgroundColor = "colors.grayColor240"
        diggButton.theme_setImage("images.tab_like_24x24_", forState: .normal)
        shareButton.theme_setImage("images.tab_share_24x24_", forState: .normal)
        emojiButton.theme_setImage("images.tabbar_icon_emoji_24x24_", forState: .normal)
        commentButton.theme_setTitleColor("colors.black", forState: .normal)
        
        navigationItem.titleView = navigationBar
        
        // 判断是否是夜间
        MyThemeStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        // 添加 导航栏右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        // 添加用纸
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: NSNotification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
        // TableView
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.zw_registerCell(cell: DongtaiCommentCell.self)
        SVProgressHUD.configuration()
        switch dongtai.item_type {
        case .commentOrQuoteContent, .commentOrQuoteOthers, .forwardArticle:
            tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
                // 获取用户详情其他类型的详情的评论数据
                NetworkTool.loadUserDetailQuoteDongtaiComents(id: self!.dongtai.id, offset: self!.comments.count, completionHandler: { (comments) in
                    self!.reloadData(comments)
                })
            })
        case .postContent:
            tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
                // 获取用户详情一般的详情的评论数据
                NetworkTool.loadUserDetailNormalDongtaiComents(groupId: Int(self!.dongtai.id_str)!, offset: self!.comments.count, count: 20, completionHandler: { (comments) in
                    self!.reloadData(comments)
                })
            })
        default:
            break
        }
        tableView.mj_footer.beginRefreshing()
    }
    
    /// 刷新数据
    private func reloadData(_ comments: [DongtaiComment]) {
        if tableView.mj_footer.isRefreshing {
            tableView.mj_footer.endRefreshing()
        }
        tableView.mj_footer.pullingPercent = 0.0
        if comments.count == 0 {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            SVProgressHUD.showInfo(withStatus: "没有更多数据了")
            return
        }
        self.comments += comments
        tableView.reloadData()
    }
}

// MARK: - 点击事件
extension DongtaiDetailViewController {
    
    /// 点击事件
    private func selectedAction() {
        headerView.didSelectDiggButton = { [weak self] (dongtai) in
            let userDiggVC = UserDiggViewController()
            userDiggVC.userId = dongtai.id
            self!.navigationController?.pushViewController(userDiggVC, animated: true)
        }
    }
    
    /// 右侧按钮点击
    @objc private func rightBarButtonItemClicked() {
        
    }
    
    /// 通知
    @objc private func receiveDayOrNightButtonClicked(notification: Notification) {
        let selected = notification.object as! Bool
        MyThemeStyle.setupNavigationBarStyle(self, selected)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: selected ? "new_more_titlebar_night_24x24_" : "new_more_titlebar_24x24_"), style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
    }
    
    /// 写评论覆盖的按钮点击
    @IBAction func coverButtonClicked(_ sender: UIButton) {
        // 弹出 postCommentView
        popPostCommentView(false)
    }
    
    /// emoji 按钮点击
    @IBAction func emojiButtonClicked(_ sender: UIButton) {
        // 弹出 postCommentView
        popPostCommentView(true)
    }
    
    /// 点赞的按钮点击
    @IBAction func diggButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 分享的按钮点击
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 弹出 postCommentView
    private func popPostCommentView(_ isEmojiButtonSelected: Bool) {
        let postCommentView = PostCommentView.loadViewFromNib()
        postCommentView.placeholderLabel.text = "优质评论将会被优先展示"
        postCommentView.isEmojiButtonSelected = isEmojiButtonSelected
        UIApplication.shared.keyWindow?.backgroundColor = .white
        UIApplication.shared.keyWindow?.addSubview(postCommentView)
    }
}

// MARK: - TableView
extension DongtaiDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.titleLabel.isHidden = (scrollView.contentOffset.y >= 50)
        navigationBar.nameButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.avatarButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.followersButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.vImageView.isHidden = (scrollView.contentOffset.y <= 50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as DongtaiCommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let comment = comments[indexPath.row]
        let postCommentView = PostCommentView.loadViewFromNib()
        if comment.screen_name != "" {
            postCommentView.placeholderLabel.text = "回复 \(comment.screen_name):"
        } else if comment.user.user_id != 0 {
            if comment.user.screen_name != "" {
                postCommentView.placeholderLabel.text = "回复 \(comment.user.screen_name):"
            }
        }
        view.addSubview(postCommentView)
    }
}
