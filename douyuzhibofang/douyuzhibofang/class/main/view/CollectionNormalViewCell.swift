//
//  CollectionNormalViewCell.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/11.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

class CollectionNormalViewCell: UICollectionViewCell {

    @IBOutlet weak var overImageV: UIImageView!
    @IBOutlet weak var onLineL: UIButton!
    @IBOutlet weak var homeL: UILabel!
    @IBOutlet weak var personName: UILabel!
    
    var model : AnchorModel? {
        didSet{
            guard let model = model else { return }
            
            var onLineStr : String = ""
            if model.online > 10000 {
                onLineStr =  "\(Int(model.online/10000))万在线"
            } else {
                onLineStr = "\(Int(model.online))在线"
            }
            onLineL.setTitle(onLineStr, for: .normal)
            homeL.text = model.nickname
            personName.text = model.room_name
            overImageV.kf.setImage(with: URL.init(string: model.vertical_src))
        }
    }
    
}
