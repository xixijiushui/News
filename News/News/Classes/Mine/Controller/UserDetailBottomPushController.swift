//
//  UserDetailBottomPushController.swift
//  News
//
//  Created by 赵伟 on 2018/12/12.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import WebKit

class UserDetailBottomPushController: UIViewController {

    var url: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView()
        webView.frame = view.bounds
        webView.load(URLRequest(url: URL(string: url!)!))
        view.addSubview(webView)
    }

}
