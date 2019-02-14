//
//  OfflineDownloadViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/10.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

class OfflineDownloadViewController: UITableViewController {

    /// 标题数组
    fileprivate var titles = [HomeNewsTitle]()
    /// 标题数据表
    fileprivate let newsTitleTable = NewsTitleTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.zw_registerCell(cell: OfflineDownloadCell.self)
        tableView.rowHeight = 44
        tableView.theme_separatorColor = "colors.separatorViewColor"
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
        // 从数据库获取数据,赋值给标题数组
        titles = newsTitleTable.selectAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as OfflineDownloadCell
        let newsTitle = titles[indexPath.row]
        cell.homeNewsTitle = newsTitle
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var homeNewsTitle = titles[indexPath.row]
        // 取反
        homeNewsTitle.selected = !homeNewsTitle.selected
        let cell = tableView.cellForRow(at: indexPath) as! OfflineDownloadCell
        cell.rightImageView.theme_image = homeNewsTitle.selected ? "images.air_download_option_press" : "images.air_download_option"
        // 替换数据
        titles[indexPath.row] = homeNewsTitle
        newsTitleTable.update(homeNewsTitle)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth, height: 44))
        label.text = "我的频道"
        label.theme_textColor = "colors.black"
        let sepeartorView = UIView(frame: CGRect(x: 0, y: 43, width: screenWidth, height: 1))
        sepeartorView.theme_backgroundColor = "colors.separatorViewColor"
        view.addSubview(label)
        view.addSubview(sepeartorView)
        return view
    }
}
