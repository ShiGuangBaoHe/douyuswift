//
//  BaseTabberViewController.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/6.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

class BaseTabberViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTabbar()
    }
    
    private func  initTabbar () {
        
        let tabbarNames          = ["首页","直播","关注","我的"]
        let tabbarNormalImgs     = ["btn_home_normal","btn_column_normal","btn_live_normal","btn_user_normal"]
        let tabbarSelectedImgs   = ["btn_home_selected","btn_column_selected","btn_live_selected","btn_user_selected"]
        
        let classArr             = ["homeViewController","liveViewController","followViewController","mySelfViewController"]
        

        for index in 0..<tabbarNames.count {
            
            let classN       = "douyuzhibofang." + classArr[index]
            
            let  vc          = NSClassFromString(classN) as! UIViewController.Type
            
            let  childClass  = vc.self.init()

            let nav          = BaseNavViewController(rootViewController: childClass)

            addChildViewController(nav)

            nav.tabBarItem = UITabBarItem(title: tabbarNames[index], image: UIImage(named: tabbarNormalImgs[index]), selectedImage: UIImage(named: tabbarSelectedImgs[index]))
            
        }
    }
    

}

extension BaseTabberViewController{
    
}
