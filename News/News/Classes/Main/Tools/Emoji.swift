//
//  Emoji.swift
//  News
//
//  Created by 赵伟 on 2018/12/11.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import Foundation
import HandyJSON

struct Emoji {
    
    var id = ""
    
    var name = ""
    
    var png = ""
    
    var isDelete = false
    
    var isEmpty = false
    
    init(id: String = "", name: String = "", png: String = "", isDelete: Bool = false, isEmpty: Bool = false) {
        self.id = id
        self.name = name
        self.png = png
        self.isDelete = isDelete
        self.isEmpty = isEmpty
    }
}

struct EmojiManager {
    
    /// emoji数组
    var emojis = [Emoji]()
    
    init() {
        /** 加入删除和空,此方法不用
        // 获取 emoji.plist 的路径
        let path = Bundle.main.path(forResource: "emoji.plist", ofType: nil)
        // 根据 plist 文件读取数据
        let array = NSArray(contentsOfFile: path!) as! [[String: String]]
        // 字典转成模型
        emojis = array.compactMap({
            Emoji.deserialize(from: $0 as NSDictionary)
        })
        */
        // 获取 emoji_sort.plist 的路径
        let arrayPath = Bundle.main.path(forResource: "emoji_sort.plist", ofType: nil)
        // 根据plist文件读取数据
        let emojiSorts = NSArray(contentsOfFile: arrayPath!) as! [String]
        // 获取emoji_mapping.plist路径
        let mappingPath = Bundle.main.path(forResource: "emoji_mapping.plist", ofType: nil)
        // 根据plist文件读取数据
        let emojiMapping = NSDictionary(contentsOfFile: mappingPath!)
        // 临时数组
        var temps = [Emoji]()
        // 遍历
        for (index, id) in emojiSorts.enumerated() {
            if index != 0 && index % 20 == 0 {
                temps.append(Emoji(isDelete: true))
            }
            temps.append(Emoji(id: id, png: "emoji_\(id)_32x32_"))
        }
        // 遍历字典
        emojiMapping?.enumerateKeysAndObjects({ (key, value, stop) in
            emojis = temps.compactMap({
                var emoji = $0
                if emoji.id == "\(value)" {
                    emoji.name = "\(key)"
                }
                return emoji
            })
        })
        // 判断分页是否有剩余
        let count = emojis.count % 21
        guard count != 0 else { return }
        // 添加空白表情
        for index in count..<21 {
            if index == 20 {
                emojis.append(Emoji(isDelete: true))
            } else {
                emojis.append(Emoji(isEmpty: true))
            }
        }
    }
    
    /// 显示 emoji 表情
    func showEmoji(content: String, font: UIFont) -> NSMutableAttributedString {
        // 将 content 转为 attributrdString
        let attributedString = NSMutableAttributedString(string: content)
        // emoji 正则
        let emojiPattern = "\\[.*?\\]"
        // 创建正则,匹配 emoji i表情
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        // 开始匹配,返回结果
        let results = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        
        if results.count != 0 {
            // 倒序替换
            for index in stride(from: results.count - 1, through: 0, by: -1) {
                // 取出结果的范围
                let result = results[index]
                // 取出emoji的名字
                let emojiName = (content as NSString).substring(with: result.range)
                let attachment = NSTextAttachment()
                // 取出对应的 emoji 模型
                guard let emoji = emojis.filter({
                    $0.name == emojiName
                }).first else {
                    return attributedString
                }
                // 设置图片
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                let attributedImageStr = NSAttributedString(attachment: attachment)
                // 将图片替换成文字
                attributedString.replaceCharacters(in: result.range, with: attributedImageStr)
            }
        }
        return attributedString
    }
}
