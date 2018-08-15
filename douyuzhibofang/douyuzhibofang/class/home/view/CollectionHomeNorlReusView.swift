//
//  CollectionHomeNorlReusView.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/10.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

class CollectionHomeNorlReusView: UICollectionReusableView {

    //MARK: -- 属性
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    
    var model : AnchorGroup? {
        didSet {
            titleL.text = model?.tag_name
            typeIcon.image = UIImage(named: model?.icon_name ?? "home_header_normal")
        }
    }
}
