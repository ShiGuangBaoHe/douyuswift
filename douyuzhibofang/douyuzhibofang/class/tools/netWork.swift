//
//  netWork.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/11.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit
import Alamofire


enum  NetType {
    case get
    case post
}

class netWork {

    class func request(_ type:NetType , url:String , param:[String : Any]? = nil , finishedCallBack :  @escaping ( _ result : Any) -> () ) {
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(url, method: method, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? "dsd")
                return
            }
            finishedCallBack(result)
        }
    }
    
}
