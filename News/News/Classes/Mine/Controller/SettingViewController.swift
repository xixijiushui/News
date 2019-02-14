//
//  SettingViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/10.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import Kingfisher

class SettingViewController: UITableViewController {

    var sections = [[SettingModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置状态栏属性
        navigationController?.navigationBar.barStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as SettingCell
        let rows = sections[indexPath.section]
        cell.setting = rows[indexPath.row]
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                calculateDiskCachSize(cell)
            case 2:
                cell.selectionStyle = .none
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:  // 清理缓存
                clearCacheAlertController(cell)
            case 1:  // 设置字体大小
                setupFontAlertController(cell)
            case 3:  // 非 WiFi 网络流量
                setupNetworkAlertController(cell)
            case 4:  // 非 WiFi 网络播放提醒
                setupPlayNoticeAlertController(cell)
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0:  // 离线下载
                let offlineDownloadVC = OfflineDownloadViewController()
                offlineDownloadVC.navigationItem.title = "离线下载"
                navigationController?.pushViewController(offlineDownloadVC, animated: true)
            default: break
            }
        default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SettingViewController {
    fileprivate func setupUI() {
        // plistl 路径
        let path = Bundle.main.path(forResource: "settingPlist", ofType: "plist")
        // 获取数据
        let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
//        for dicts in cellPlist {
//            let array = dicts as! [[String: Any]]
//            var rows = [SettingModel]()
//            for dict in array {
//                let setting = SettingModel.deserialize(from: dict as NSDictionary)
//                rows.append(setting!)
//            }
//            sections.append(rows)
//        }
        
        sections = cellPlist.compactMap { (section) in
            (section as! [Any]).compactMap({ (row) in
                SettingModel.deserialize(from: row as? NSDictionary)
            })
        }
        
        tableView.zw_registerCell(cell: SettingCell.self)
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.theme_separatorColor = "colors.tableViewBackgroundColor"
        tableView.theme_backgroundColor = "colors.tableViewBackgroundColor"
    }
}

extension SettingViewController {
    fileprivate func calculateDiskCachSize(_ cell: SettingCell) {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskCacheSize { (size) in
            let sizeM = Double(size) / 1024.0 / 1024.0
            let sizeString = String(format: "%.2fM", sizeM)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
            cell.rightTitleLabel.text = sizeString
        }
    }
    
//    // 接收到设置缓存
//    @objc fileprivate func loadCacheSize(notification: Notification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
//        cell.rightTitleLabel.text = userInfo["cacheSize"] as? String
//    }
//
//    // 接收到更改文字大小
//    @objc fileprivate func changeFontSize(notification: Notification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let indexPath = IndexPath(row: 1, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
//        cell.rightTitleLabel.text = userInfo["fontSize"] as? String
//    }
//
//    // 接收到非 WiFi 网络流量
//    @objc fileprivate func changeNetworkMode(notification: Notification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let indexPath = IndexPath(row: 3, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
//        cell.rightTitleLabel.text = userInfo["networkMode"] as? String
//    }
//
//    // 接收到非 WiFi 网络播放提醒
//    @objc fileprivate func changePlayNotice(notification: Notification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let indexPath = IndexPath(row: 4, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
//        cell.rightTitleLabel.text = userInfo["playNotice"] as? String
//    }
    
    private func clearCacheAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "确定清除所有缓存？问答草稿、离线下载及图片均会被清除", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            let sizeString = "0.00M"
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cacheSizeM"), object: self, userInfo: ["cacheSize": sizeString])
            cell.rightTitleLabel.text = sizeString
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupFontAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "非WiFi网络播放提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let smallAction = UIAlertAction(title: "小", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "小"])
            cell.rightTitleLabel.text = "小"
        }
        let middleAction = UIAlertAction(title: "中", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "中"])
            cell.rightTitleLabel.text = "中"
        }
        let bigAction = UIAlertAction(title: "大", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "大"])
            cell.rightTitleLabel.text = "大"
        }
        let largeAction = UIAlertAction(title: "特大", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fontSize"), object: self, userInfo: ["fontSize": "特大"])
            cell.rightTitleLabel.text = "特大"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(smallAction)
        alertController.addAction(middleAction)
        alertController.addAction(bigAction)
        alertController.addAction(largeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupNetworkAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "非WiFi网络流量", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestAction = UIAlertAction(title: "最佳效果(下载大图)", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "最佳效果(下载大图)"])
            cell.rightTitleLabel.text = "最佳效果(下载大图)"
        }
        let betterAction = UIAlertAction(title: "较省流量(智能下图)", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "较省流量(智能下图)"])
            cell.rightTitleLabel.text = "较省流量(智能下图)"
        }
        let leastAction = UIAlertAction(title: "极省流量(智能下图)", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkMode"), object: self, userInfo: ["networkMode": "极省流量(智能下图)"])
            cell.rightTitleLabel.text = "极省流量(智能下图)"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(bestAction)
        alertController.addAction(betterAction)
        alertController.addAction(leastAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupPlayNoticeAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "非WiFi网络播放提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let everyAction = UIAlertAction(title: "每次提醒", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playNotice"), object: self, userInfo: ["playNotice": "每次提醒"])
            cell.rightTitleLabel.text = "每次提醒"
        }
        let onceAction = UIAlertAction(title: "提醒一次", style: .default) { (_) in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playNotice"), object: self, userInfo: ["playNotice": "提醒一次"])
            cell.rightTitleLabel.text = "提醒一次"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(everyAction)
        alertController.addAction(onceAction)
        present(alertController, animated: true, completion: nil)
    }
}
