//
//  CollectionPrettyCell.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/11.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionPrettyCell: UICollectionViewCell {

    @IBOutlet weak var onLineL: UILabel!
    @IBOutlet weak var overImageV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var addressBtn: UIButton!
    
    var model : AnchorModel? {
        didSet{
            guard let model = model else { return }
           
            var onLineStr : String = ""
            if model.online > 10000 {
                onLineStr =  "\(Int(model.online/10000))万在线"
            } else {
              onLineStr = "\(Int(model.online))在线"
            }
            onLineL.text = onLineStr
            nameL.text = model.nickname
            addressBtn.setTitle(model.anchor_city, for: .normal)
           // kingfisher 设置图片
            overImageV.kf.setImage(with: URL.init(string: model.vertical_src))
            
        }
    }
}
