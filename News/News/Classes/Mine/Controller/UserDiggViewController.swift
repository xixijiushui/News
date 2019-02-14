//
//  UserDiggViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserDiggViewController: UITableViewController {

    var userId: Int = 0
    
    var digglist = [DongtaiUserDigg]()
    
    var cursor: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "赞过的人"
        SVProgressHUD.configuration()
        tableView.tableFooterView = UIView()
        tableView!.zw_registerCell(cell: UserDiggCell.self)
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
            NetworkTool.loadDongtaiDetailUserDiggList(id: self!.userId, offset: self!.cursor * 20, completionHandler: { (digglist) in
                if self!.tableView.mj_footer.isRefreshing {
                    self!.tableView.mj_footer.endRefreshing()
                }
                self!.tableView.mj_footer.pullingPercent = 0.0
                if digglist.count == 0 {
                    self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                    return
                }
                self!.cursor += 1
                self!.digglist += digglist
                self!.tableView.reloadData()
            })
        })
        tableView.mj_footer.beginRefreshing()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return digglist.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as UserDiggCell
        cell.user = digglist[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = digglist[indexPath.row]
        let userDetailVC = UserDetailViewController2()
        userDetailVC.userId = user.user_id
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
