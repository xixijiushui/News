//
//  PostCommentView.swift
//  News
//
//  Created by 赵伟 on 2018/12/19.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit
import IBAnimatable

class PostCommentView: UIView, NibLoadable {
    
    /// emoji按钮是否选中
    var isEmojiButtonSelected = false {
        didSet {
            if isEmojiButtonSelected { // 点击了emoji按钮
                emojiButton.isSelected = isEmojiButtonSelected
                UIView.animate(withDuration: 0.25) {
                    self.changeConstraints()
                    self.bottomViewBottom.constant = emojiItemWidth * 3 + self.toolbarHeight.constant + self.emojiViewBottom.constant
                    self.layoutIfNeeded()
                }
                
                // 判断pageControlView的子控件是否为0
                if pageControlView.subviews.count == 0 {
                    pageControl.numberOfPages = emojiManger.emojis.count / 21
                    pageControl.center = pageControlView.center
                    pageControlView.addSubview(pageControl)
                }
            } else {
                textView.becomeFirstResponder()
            }
        }
    }
    
    /// 底部view
    @IBOutlet weak var bottomView: UIView!
    /// 底部约束
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    /// 转发按钮
    @IBOutlet weak var forwardButton: UIButton!
    /// @按钮
    @IBOutlet weak var atButton: UIButton!
    /// emoji按钮
    @IBOutlet weak var emojiButton: UIButton!
    /// 发布按钮
    @IBOutlet weak var postButton: UIButton!
    /// 背景view
    @IBOutlet weak var textBackgroundView: AnimatableView!
    /// textview
    @IBOutlet weak var textView: UITextView!
    /// textview高度
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    /// 占位label
    @IBOutlet weak var placeholderLabel: UILabel!
    
    /// emojiview
    @IBOutlet weak var emojiView: UIView!
    /// emojiview底部约束
    @IBOutlet weak var emojiViewBottom: NSLayoutConstraint!
    /// emoji视图
    @IBOutlet weak var collectionView: UICollectionView!
    /// 工具条(包括emoji 和 pagecontrol)高度
    @IBOutlet weak var toolbarHeight: NSLayoutConstraint!
    /// emoji 按钮高度
    @IBOutlet weak var emojiButtonHeight: NSLayoutConstraint!
    /// pagecontrol
    @IBOutlet weak var pageControlView: UIView!
    
    private lazy var emojiManger = EmojiManager()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.theme_currentPageIndicatorTintColor = "colors.currentPageIndicatorTintColor"
        pageControl.theme_pageIndicatorTintColor = "colors.pageIndicatorTintColor"
        return pageControl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        width = screenWidth
        height = screenHeight
        bottomView.theme_backgroundColor = "colors.cellBackgroundColor"
        textBackgroundView.theme_backgroundColor = "colors.grayColor240"
        forwardButton.isSelected = true
        forwardButton.theme_setImage("images.loginReadButton", forState: .normal)
        forwardButton.theme_setImage("images.loginReadButtonSelected", forState: .selected)
        atButton.theme_setImage("images.toolbar_icon_at_24x24_", forState: .normal)
        emojiButton.theme_setImage("images.toolbar_icon_emoji_24x24_", forState: .normal)
        emojiButton.theme_setImage("images.toolbar_icon_keyboard_24x24_", forState: .selected)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        collectionView.collectionViewLayout = EmojiLayout()
        collectionView.zw_registerCell(cell: EmojiCollectionCell.self)
    }
    
    /// 改变约束
    private func changeConstraints() {
        self.emojiButtonHeight.constant = 44
        self.toolbarHeight.constant = self.emojiButtonHeight.constant + 20
//        self.emojiViewBottom.constant = isIPhoneX ? 34 : 0
    }
    
    /// 重置约束
    private func resetConstraints() {
        self.emojiButtonHeight.constant = 0
        self.toolbarHeight.constant = 0
        self.bottomViewBottom.constant = 0
        self.emojiViewBottom.constant = 0
        layoutIfNeeded()
    }
    
    /// 键盘将要弹起
    @objc private func keyboardWillShow(notification: Notification) {
        let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! TimeInterval
        // iPhoneX 键盘高度是 291 如果有输入预测高度 42，高度变为 333 ,其他手机的键盘高度是 216
        UIView.animate(withDuration: duration) {
            self.changeConstraints()
            self.bottomViewBottom.constant = frame.size.height - (isIPhoneX ? 34 : 0)
            self.layoutIfNeeded()
        }
    }
    
    /// 键盘将要隐藏
    @objc private func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration) {
            self.resetConstraints()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
        
        if isEmojiButtonSelected {
            UIView.animate(withDuration: 0.25, animations: {
                self.resetConstraints()
            }) { (_) in
                self.removeFromSuperview()
            }
        } else {
            removeFromSuperview()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PostCommentView {
    
    /// 转发按钮点击
    @IBAction func forwardButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func atButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func emojiButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textView.resignFirstResponder()
            isEmojiButtonSelected = true
        } else {
            textView.becomeFirstResponder()
        }
    }
}

extension PostCommentView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        placeholderLabel.isHidden = textView.text.count != 0
        postButton.setTitleColor((textView.text.count != 0) ? .blueFontColor() : .grayColor210(), for: .normal)
        return true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // 当textview将要开始编辑的时候,设置emoji按钮不选中
        emojiButton.isSelected = false
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count != 0
        postButton.setTitleColor((textView.text.count != 0) ? .blueFontColor() : .grayColor210(), for: .normal)
        setupHeight()
    }
    
    fileprivate func setupHeight() {
        let height = Calculate.attributedTextHeight(text: textView.attributedText, width: textView.width)
        if height <= 30 {
            textViewHeight.constant = 30
        } else if height >= 80 {
            textViewHeight.constant = 80
        } else {
            textViewHeight.constant = height
        }
        layoutIfNeeded()
    }
}

extension PostCommentView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiManger.emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zw_dequeueReusableCell(indexPath: indexPath) as EmojiCollectionCell
        cell.emoji = emojiManger.emojis[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        textView.setAttributedText(emoji: emojiManger.emojis[indexPath.item])
        placeholderLabel.isHidden = textView.attributedText.length != 0
        setupHeight()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / scrollView.width
        pageControl.currentPage = Int(currentPage + 0.5)
    }
}
