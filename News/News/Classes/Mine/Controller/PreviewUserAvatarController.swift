//
//  PreviewUserAvatarController.swift
//  News
//
//  Created by 赵伟 on 2018/12/18.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import Photos

class PreviewUserAvatarController: UIViewController {

    /// 头像URL
    var avatar_url = ""
    var avatarRect: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        let avatarImageView = UIImageView()
        avatarImageView.kf.setImage(with: URL(string: avatar_url))
        view.addSubview(avatarImageView)
        
        UIView.animate(withDuration: 0.25, animations: {
            avatarImageView.frame = self.avatarRect
        }) { (_) in
            UIView.animate(withDuration: 0.25, animations: {
                avatarImageView.frame = CGRect(x: 0, y: (self.view.height - screenWidth) * 0.5, width: screenWidth, height: screenWidth)
            })
        }
        
        let button = UIButton(type: .custom)
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        button.size = CGSize(width: 50, height: 28)
        button.x = screenWidth - button.width - 15
        button.y = screenHeight - button.height - (isIPhoneX ? 50 : 15)
        view.addSubview(button)
    }
    
    @objc func saveButtonClicked(_ sender: UIButton) {
        ImageDownloader.default.downloadImage(with: URL(string: avatar_url)!, retrieveImageTask: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
            let progress = Float(receivedSize) / Float(totalSize)
            SVProgressHUD.showProgress(progress)
            SVProgressHUD.setBackgroundColor(.clear)
            SVProgressHUD.setForegroundColor(.white)
        }) { (image, error, imageURL, data) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: { (success, error) in
                if success {
                    SVProgressHUD.showSuccess(withStatus: "保存成功")
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }

}
