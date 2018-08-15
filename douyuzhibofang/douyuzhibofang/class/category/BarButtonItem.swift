//
//  File.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/7.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

//扩充 UIBarButtonItem 类，，相似于oc  的类别
extension UIBarButtonItem{
    
    //创造类方法，用类名 . 调用
    /*
     **
    class func CreateItem (normalImgName:String,selectedImgName:String,size:CGSize) ->UIBarButtonItem{
        
        let barBtn = UIButton()
        barBtn.setImage(UIImage(named:normalImgName), for: .normal)
        barBtn.setImage(UIImage(named:selectedImgName), for: .selected)
        barBtn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: barBtn)
    }
 */
    /*
       用括号调用，，swift 提倡用这种方法
       init  方法必须满足两个条件 1. 便利构造函数 以 convenience 开头
           2. 在构造函数中必须调用一个设计的构造函数 （self）
    */
    convenience init(normalImgName:String,selectedImgName:String = "",size:CGSize = CGSize.zero) {
        let barBtn = UIButton()
        barBtn.setImage(UIImage(named:normalImgName), for: .normal)
        if selectedImgName != "" {
            barBtn.setImage(UIImage(named:selectedImgName), for: .selected)
        }
        if size == CGSize.zero {
            barBtn.sizeToFit()
        }else{
             barBtn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
       
        self.init(customView:barBtn)
    }
    
}
