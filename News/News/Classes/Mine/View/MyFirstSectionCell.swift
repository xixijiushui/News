//
//  MyFirstSectionCell.swift
//  News
//
//  Created by 赵伟 on 2018/12/7.
//  Copyright © 2018年 Zvonimir. All rights reserved.
//

import UIKit

protocol MyFirstSectionCellDelegate: class {
    func myFirstSectionCell(_ firstCell: MyFirstSectionCell, myConcern: MyConcern)
}

class MyFirstSectionCell: UITableViewCell, RegisterCellOrNib {
    
    weak var delegate: MyFirstSectionCellDelegate?
    // 标题
    @IBOutlet weak var leftLabel: UILabel!
    // 副标题
    @IBOutlet weak var rightLabel: UILabel!
    // 单个关注的图片
    @IBOutlet weak var leftImageView: UIImageView!
    // 右箭头
    @IBOutlet weak var rightImageview: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var topView: UIView!
    // 分割线
    @IBOutlet weak var separatorView: UIView!
    
    var myConcerns = [MyConcern]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var myCellModel: MyCellModel? {
        didSet {
            leftLabel.text = myCellModel?.text
            rightLabel.text = myCellModel?.grey_text
        }
    }
    
    var myConcern: MyConcern? {
        didSet {
            leftImageView.kf.setImage(with: URL(string: (myConcern?.icon)!))
            rightLabel.text = myConcern?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = MyconcernFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.zw_registerCell(cell: MyConcernCell.self)
        
        /// 设置主题
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        rightImageview.theme_image = "images.cellRightArrow"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
        topView.theme_backgroundColor = "colors.cellBackgroundColor"
        collectionView.theme_backgroundColor = "colors.cellBackgroundColor"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MyFirstSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myConcerns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.zw_dequeueReusableCell(indexPath: indexPath) as MyConcernCell
        cell.myConcern = myConcerns[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let concern = myConcerns[indexPath.item]
        delegate?.myFirstSectionCell(self, myConcern: concern)
    }
}

class MyconcernFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        // cell 大小
        itemSize = CGSize(width: 58, height: 74)
        // 横/纵向间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // cell 上下左右间距
        sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        // 水平滚动
        scrollDirection = .horizontal
    }
}
