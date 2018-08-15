//
//  homeViewController.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/6.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

private let titleViewH:CGFloat = 40


class homeViewController: UIViewController {

    //MARK:---lazy Load :::
    private lazy var pageTitleView:PageTitleView = {[weak self] in
        
        let rect = CGRect(x: 0, y: kStatusBarH+kNavBarH, width:kScreenW, height: titleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: rect, titles: titles)
        titleView.backgroundColor = UIColor.white
        titleView.delegate = self
        return titleView
    }()
    private lazy var  pageContentV : PageContentView = {[weak self] in
        let pageConY = kStatusBarH+kNavBarH+titleViewH
        let pageConFrame = CGRect(x: 0, y: pageConY, width: kScreenW, height: kScreenH-pageConY-kTabbarH)
        var vControlls=[UIViewController]()
        vControlls.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r:CGFloat(arc4random_uniform(225)) , g: CGFloat(arc4random_uniform(225)), b: CGFloat(arc4random_uniform(225)))
            vControlls.append(vc)
        }
        
        let pageContentV = PageContentView(frame:pageConFrame , childVCs: vControlls, fatherVC: self)
        pageContentV.delegate = self
        return pageContentV
    }()
    
    
    //MARK: 入口函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.不需要设置scrollView  的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        setUI()
        //添加头部滑动视图
        view.addSubview(pageTitleView)
        //添加内容视图
        view.addSubview(pageContentV)
    }
}

//MARK:  --- 设置UI界面
extension homeViewController {
    
    private func setUI(){
        
        setNavigationBar()
    }
    
    private func setNavigationBar(){
        //这也是自己创建的方法，
        navigationItem.leftBarButtonItem = UIBarButtonItem(normalImgName:"logo")
        
        let size = CGSize(width: 35, height: 35)
  /*
         **  这是调用类别的类方法的方法。
        let  historyItem = UIBarButtonItem.CreateItem(normalImgName: "image_my_history", selectedImgName: "Image_my_history_click", size: size)
         let  searchItem = UIBarButtonItem.CreateItem(normalImgName: "btn_search", selectedImgName: "btn_search_clicked", size: size)
         let  qrcodeItem = UIBarButtonItem.CreateItem(normalImgName: "Image_scan", selectedImgName: "Image_scan_click", size: size)
    */
      //自己封装的构造函数的方法调用
       let historyItem = UIBarButtonItem(normalImgName: "image_my_history", selectedImgName: "Image_my_history_click", size: size)
       let searchItem = UIBarButtonItem(normalImgName: "btn_search", selectedImgName: "btn_search_clicked", size: size)
       let qrcodeItem = UIBarButtonItem(normalImgName: "Image_scan", selectedImgName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems =  [historyItem,searchItem,qrcodeItem]
    }
}
//MARK: -- 实现 PageTitleViewDelegate
extension homeViewController : PageTitleViewDelegate {
    
    func pageTitleViewClickTitle(pageTitleV: PageTitleView, clickIndex: Int) {
        pageContentV.setScrollIndexView(index: clickIndex)
    }
}
//MARK: -- 实现 PageContentViewDelegate

extension homeViewController : PageContentViewDelegate {
    
    func pageContentViewScrollCollectionEvent(pageContentV: PageContentView, progress: CGFloat, oldIndex: Int, ChangedIndex: Int) {
        pageTitleView.titleViewScroll(progress: progress, oldIndex: oldIndex, changedIndex: ChangedIndex)
    }
}




