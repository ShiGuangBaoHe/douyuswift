//
//  RecommendViewModel.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/12.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

class RecommendViewModel {
   
    //MARK: -- 懒加载
    lazy var  anchorGroups : [AnchorGroup] = [AnchorGroup]()
    private lazy var  bigDataGroup : AnchorGroup = AnchorGroup()
    private lazy var  prettyGroup : AnchorGroup = AnchorGroup()
}

extension RecommendViewModel {
    
    func requestData (finishBack : @escaping ()->()) {
        let newTime = NSDate()
        let timeInterval = Int(newTime.timeIntervalSince1970)
        print(timeInterval)
        let param = ["limit":4,"offset":0,"time":timeInterval]
        //参数 ： time 当前时间字符串  limit 获取数据的个数  offset  获取数据偏移量，从第几条数据开始获取
      
        let dGroup = DispatchGroup()
    
        //1.推荐数据 http://capi.douyucdn.cn/api/v1/getbigDataRoom
        //网络队列组监听异步加载是否完成
        dGroup.enter()
        
        netWork.request(.post, url: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", param: ["time":timeInterval]) { (result) in
            let data = result as! [String:NSObject]
            let daa =  data["data"] as! [[String:NSObject]]
          
            self.bigDataGroup.icon_name = "home_header_hot"
            self.bigDataGroup.tag_name = "热门"
            for dict in daa {
                let anc = AnchorModel(dic: dict)
                self.bigDataGroup.anchors.append(anc)
            }
            print("第一组数据")
            dGroup.leave()
        }
        
        //2.颜值数据：http://capi.douyucdn.cn/api/v1/getVerticalRoom?limit=8/offset=0/time=1534215352
        dGroup.enter()
        netWork.request(.post, url: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", param: param) { (result) in
            let data = result as! [String:NSObject]
            let daa =  data["data"] as! [[String:NSObject]]
            
            self.prettyGroup.icon_name = "home_header_phone"
            self.prettyGroup.tag_name = "颜值"
            
            for (index,dict) in daa.enumerated() {
                if index < 4 {
                    let anc = AnchorModel(dic: dict)
                    self.prettyGroup.anchors.append(anc)
                }
            }
            print("第二组数据")
            dGroup.leave()
        }
        
       // 3.热门数据 ： http://capi.douyucdn.cn/api/v1/getHotCate
       // http://capi.douyucdn.cn/api/v1/getHotCate?limit=4/offset=0/time=1534166561
        dGroup.enter()
        netWork.request(.post, url:"http://capi.douyucdn.cn/api/v1/getHotCate" , param:param) { (result) in
            
            let data = result as! [String:NSObject]
            let daa =  data["data"] as! [[String:NSObject]]
    
            for  dic in daa{

               let group = AnchorGroup(dict: dic)
                self.anchorGroups.append(group)
            }
            print("第三组数据")
            dGroup.leave()
        }
        
        //监听所有网络请求都成功后
        dGroup.notify(queue: DispatchQueue.main) {
             print("第四组数据")
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishBack()
        }
    }
}
