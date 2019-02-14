//
//  UserDetailViewController2.swift
//  News
//
//  Created by 赵伟 on 2018/12/19.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class UserDetailTableView: UITableView, UIGestureRecognizerDelegate {
    // 底层tableview实现这个方法,就可以响应上层tableview的滑动手势
    // otherGestureRecognizer 就是它上层的view持有的手势(这里的话,就是scrollview和tableview)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 保证有其他手势存在
        guard let otherView = otherGestureRecognizer.view else {
            return false
        }
        // 如果其他的手势的view是scrollview,则不响应
        if otherView.isMember(of: UIScrollView.self) {
            return false
        }
        // 其他手势是tableview的pan手势,就响应
        let isPan = gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        if isPan && otherView.isKind(of: UIScrollView.self) {
            return true
        }
        return false
    }
}

class UserDetailViewController2: UIViewController {

    @IBOutlet weak var tableView: UserDetailTableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var userId: Int = 0
    var userDetail: UserDetail?
    
    
    /// 懒加载 头部
    fileprivate lazy var headerView: UserDetailHeaderView2 = {
        let headerView = UserDetailHeaderView2.loadViewFromNib()
        return headerView
    }()
    
    /// 懒加载 底部
    fileprivate lazy var myBottomView: UserDetailBottomView = {
        let myBottomView = UserDetailBottomView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        myBottomView.delegate = self
        return myBottomView
    }()
    
    /// 懒加载 导航栏
    fileprivate lazy var navigationBar: UserDetailNavigationBar = {
        let navigationBar = UserDetailNavigationBar.loadViewFromNib()
        return navigationBar
    }()
    
    /// 懒加载 导航栏
    fileprivate lazy var topTabScrollview: TopTabScrollview = {
        let topTabScrollview = TopTabScrollview(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        return topTabScrollview
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_clear"), for: .default)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if UserDefaults.standard.bool(forKey: isNight) {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white_night"), for: .default)
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_white"), for: .default)
        }
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI
        setupUI()
        // 点击了用户或者话题
        selectedAction()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        navigationBar.size = CGSize(width: screenWidth, height: isIPhoneX ? 88 : 44)
//    }
}

extension UserDetailViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as UserDetailCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        view.addSubview(topTabScrollview)
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let navigationBarHeight: CGFloat = isIPhoneX ? -88.0 : -64.0
        
        if offsetY < navigationBarHeight {
            let totalOffset = kUserDetailHeaderBGImageViewHeight + abs(offsetY)
            let f = totalOffset / kUserDetailHeaderBGImageViewHeight
            headerView.backgroundImageView.frame = CGRect(x: -screenWidth * (f - 1) * 0.5, y: offsetY, width: screenWidth * f, height: totalOffset)
            navigationBar.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        } else {
            var alpha: CGFloat = (offsetY + 44) / 58
            alpha = min(alpha, 1.0)
            navigationBar.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: alpha)
            if alpha == 1.0 {
                navigationController?.navigationBar.barStyle = .default
                navigationBar.returnButton.theme_setImage("images.personal_home_back_black_24x24_", forState: .normal)
                navigationBar.moreButton.theme_setImage("images.new_more_titlebar_24x24_", forState: .normal)
            } else {
                navigationController?.navigationBar.barStyle = .black
                navigationBar.returnButton.theme_setImage("images.personal_home_back_white_24x24_", forState: .normal)
                navigationBar.moreButton.theme_setImage("images.new_morewhite_titlebar_22x22_", forState: .normal)
            }
            // 14 + 15 + 14
            var alpha1: CGFloat = offsetY / 57
            if offsetY >= 43 {
                alpha1 = min(alpha1, 1.0)
                navigationBar.nameLabel.isHidden = false
                navigationBar.concernButton.isHidden = false
                navigationBar.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha1)
                navigationBar.concernButton.alpha = alpha1
            } else {
                alpha1 = min(0.0, alpha1)
                navigationBar.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha1)
                navigationBar.concernButton.alpha = alpha1
            }
        }
    }
}

extension UserDetailViewController2: UserDetailBottomViewDelegate {
    
    /// 按钮点击
    private func selectedAction() {
        // 返回按钮点击
        navigationBar.didSelectGoBackButton = { [weak self] in
            self!.navigationController?.popViewController(animated: true)
        }
        // 更多按钮点击
        navigationBar.didSelectMoreButton = {
            
        }
        // 点击了关注按钮
        headerView.didSelectConcernButton = { [weak self] in
            self!.tableView.tableHeaderView = self!.headerView
        }
        // 当前的 topTab 类型
        topTabScrollview.currentTopTab = { [weak self] (topTab, index) in
            let cell = self!.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
            let dongtaiVC = self!.children[index] as! DongtaiTableViewController
            dongtaiVC.currentTopTabType = topTab.type
            // 偏移
            cell.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * screenWidth, y: 0), animated: true)
        }
    }
    
    func bottomView(clicked button: UIButton, bottomTab: BottomTab) {
        let bottomPushVC = UserDetailBottomPushController()
        bottomPushVC.navigationItem.title = "网页浏览"
        if bottomTab.children.count == 0 {
            // 没有子菜单,直接跳转网页
            bottomPushVC.url = bottomTab.value
            navigationController?.pushViewController(bottomPushVC, animated: true)
        } else {
            // 有子菜单,弹出子视图
            // 获取视图
            let sb = UIStoryboard(name: "\(UserDetailBottomPopController.self)", bundle: nil)
            let popoverVC = sb.instantiateViewController(withIdentifier: "\(UserDetailBottomPopController.self)") as! UserDetailBottomPopController
            popoverVC.childrens = bottomTab.children
            popoverVC.modalPresentationStyle = .custom
            popoverVC.didSelectedChild = { [weak self] in
                bottomPushVC.url = $0.value
                self!.navigationController?.pushViewController(bottomPushVC, animated: true)
            }
            let popoverAnimator = PopoverAnimator()
            // 转化 frame
            let rect = myBottomView.convert(button.frame, to: view)
            let popWidth = (screenWidth - CGFloat(userDetail!.bottom_tab.count + 1) * 20) / CGFloat(userDetail!.bottom_tab.count)
            let popX = CGFloat(button.tag) * (popWidth + 20) + 20
            let popHeight = CGFloat(bottomTab.children.count) * 40 + 25
            popoverAnimator.presentFrame = CGRect(x: popX, y: rect.origin.y - popHeight, width: popWidth, height: popHeight)
            popoverVC.transitioningDelegate = popoverAnimator
            present(popoverVC, animated: true, completion: nil)
        }
    }
}

extension UserDetailViewController2 {
    /// 设置UI
    fileprivate func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = navigationBar
        
        tableView.zw_registerCell(cell: UserDetailCell.self)
        tableView.tableFooterView = UIView()

        
        // 获取用户详情数据
        NetworkTool.loadUserDetail(userId: userId) { (userDetail) in
            // 获取用户详情的动态列表数据
            NetworkTool.loadUserDetailDongtaiList(userId: self.userId, maxCursor: 0, completionHandler: { (cursor, dongtais) in
                if userDetail.bottom_tab.count != 0 {
                    self.bottomViewHeight.constant = isIPhoneX ? 78 : 44
                    self.view.layoutIfNeeded()
                    self.myBottomView.bottomTabs = userDetail.bottom_tab
                    self.bottomView.addSubview(self.myBottomView)
                }
                self.userDetail = userDetail
                self.headerView.userDetail = userDetail
                self.navigationBar.userDetail = userDetail
                self.topTabScrollview.topTabs = userDetail.top_tab
                self.tableView.tableHeaderView = self.headerView
                let navigationBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0
                let rowHeight = screenHeight - navigationBarHeight - self.tableView.sectionHeaderHeight - self.bottomViewHeight.constant
                self.tableView.rowHeight = rowHeight
                // 一定要先reload一次,否则不能刷新数据,也不能设置行高
                self.tableView.reloadData()
                if userDetail.top_tab.count == 0 {
                    return
                }
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
                // 遍历
                for (index, topTab) in userDetail.top_tab.enumerated() {
                    let dongtaiVC = DongtaiTableViewController()
                    self.addChild(dongtaiVC)
                    if index == 0 {
                        dongtaiVC.currentTopTabType =  topTab.type
                    }
                    dongtaiVC.userId = userDetail.user_id
                    dongtaiVC.tableView.frame = CGRect(x: CGFloat(index) * screenWidth, y: 0, width: screenWidth, height: rowHeight)
                    cell.scrollView.addSubview(dongtaiVC.tableView)
                    if index == userDetail.top_tab.count - 1 {
                        cell.scrollView.contentSize = CGSize(width: CGFloat(userDetail.top_tab.count) * screenWidth, height: cell.scrollView.height)
                    }
                }
            })
        }
    }
    
}
