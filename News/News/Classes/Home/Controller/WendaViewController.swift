//
//  WendaViewController.swift
//  News
//
//  Created by 赵伟 on 2018/12/20.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import SVProgressHUD

class WendaViewController: UIViewController {
    
    /// tableView
    @IBOutlet weak var tableView: UITableView!
    /// 回答按钮
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var bottomView: WendaAnswerBottomView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    /// 问答数据
    var wenda = Wenda()
    
    var answers = [WendaAnswer]()
    
    var qid = 0
    var enterForm: WendaEnterFrom = .clickHeadline
    
    private lazy var headerView: WendaAnswerHeaderView = {
        let headerView = WendaAnswerHeaderView.loadViewFromNib()
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.configuration()
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView.zw_registerCell(cell: WendaAnswerCell.self)
        NetworkTool.loadProposeQuestionBrow(qid: qid, enterForm: enterForm) { (wenda) in
            self.answers = wenda.ans_list
            self.tableView.tableFooterView = UIView()
            self.bottomView.modules = wenda.module_list
            self.headerView.question = wenda.question
            self.tableView.tableHeaderView = self.headerView
            self.tableView.reloadData()
        }
        // 添加加载更多数据
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
            NetworkTool.loadMoreProposeQuestionBrow(qid: self!.qid, offset: self!.answers.count, enterForm: self!.enterForm, completionHandler: { (wenda) in
                if self!.tableView.mj_footer.isRefreshing {
                    self!.tableView.mj_footer.endRefreshing()
                }
                self!.tableView.mj_footer.pullingPercent = 0.0
                if wenda.ans_list.count == 0 {
                    self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦！")
                    return
                }
                self!.answers += wenda.ans_list
                self!.tableView.reloadData()
            })
        })
        tableView.mj_footer.isAutomaticallyChangeAlpha = true
        
        // 点击了展开按钮
        headerView.didSelectUnfoldButton = { [weak self] in
            self!.tableView.tableHeaderView = self!.headerView
        }
    }
    

}

extension WendaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.cellForRow(at: indexPath) as? WendaAnswerCell
        if cell == nil {
            cell = tableView.zw_dequeueReusableCell(indexPath: indexPath) as WendaAnswerCell
        }
        cell!.answer = answers[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return answers[indexPath.row].cellHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
