//
//  AnchorGroup.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/12.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {

    @objc  var  icon_name:String = "home_header_normal"
    @objc  var  tag_name:String = ""
    @objc  var  tag_id:String = ""

    @objc  var  room_list : [[String:NSObject]]? {
        didSet {
            guard let room_list = room_list else { return }
            
            for dic in room_list {
                  anchors.append(AnchorModel(dic: dic))
            }
         
        }
    }
   
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    //颜值数据的话，有几个属性需要自己添加
    override init() {
        
    }
    
    init(dict:[String:NSObject]){
        super.init()
        setValuesForKeys(dict)
        
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
//        if key == "room_list" {
//            if let dataArray = value as? [[String:NSObject]] {
//                for dicc in dataArray {
//                    anchors.append(AnchorModel(dic: dicc))
//                }
//            }
//        }
    }
}
