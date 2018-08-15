//
//  AnchorModel.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/13.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {

    @objc var  room_id:Int = 0
    @objc var vertical_src:String = ""
    //等于0 表示电脑直播，
    @objc var isVertical:Int = 0
    @objc var room_name:String = ""
    //主播昵称
    @objc var nickname:String = ""
    @objc var online:Int = 0
    @objc  var  anchor_city : String = ""
    
    init(dic : [String : NSObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
