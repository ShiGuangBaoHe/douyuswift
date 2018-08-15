//
//  PageTitleView.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/7.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

//MARK: -- 代理
protocol PageTitleViewDelegate : class {
    func pageTitleViewClickTitle (pageTitleV : PageTitleView , clickIndex : Int)
}
//MARK: -- 定义全局变量
private let kScrollLineH:CGFloat = 2.0
private let kNormalColor:(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectedColor:(CGFloat,CGFloat,CGFloat) = (225,128,0)


class PageTitleView: UIView {
    //MARK: 自定义属性
    private let titles:[String]
    private var currentIndex:Int = 0
    weak var delegate : PageTitleViewDelegate?
    //MARK:  懒加载
    private var scrollV:UIScrollView = {
        var scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.scrollsToTop = false
        scrollV.isPagingEnabled = false
        scrollV.bounces = false //内容不要超过视图
        return scrollV
        
    }()
    private var bottomScrollLine:UILabel = {
        var bottomScrollLine = UILabel()
        bottomScrollLine.backgroundColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        return bottomScrollLine
    }()
    private var titleLabels:[UILabel] = [UILabel]()
    
    
    //MARK: -- init 初始化创建
    init(frame: CGRect,titles:[String]) {
        
        self.titles = titles
        super.init(frame:frame)
        creatUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView {
    //创建UI 视图
    private func creatUI(){
        //1<创建最下层的scrollView
        addSubview(scrollV)
        scrollV.frame = bounds
        //2<设置title lable
        setTitleView()
        //3<设置底部的滑动条
        setBottomScrollLine()
    }
    //设置title  label
    private func setTitleView(){
        
        //
        let lableW = frame.width/CGFloat(titles.count)
        let lableH = frame.height - kScrollLineH
        let lableY = 0.0
        
        for (index,title) in titles.enumerated() {
            
            let titLable = UILabel()
            titLable.text = title
            titLable.tag  = index
            titLable.font = UIFont.systemFont(ofSize: 16.0)
            titLable.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            titLable.textAlignment = .center
            let lableX = lableW * CGFloat(index)
            titLable.frame = CGRect(x: lableX, y: CGFloat(lableY), width: lableW, height: lableH)
            
           scrollV.addSubview(titLable)
            
            //label 加点击手势
            titLable.isUserInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action:#selector(titleLabelCheck(tapGR:)))
            titLable.addGestureRecognizer(tapGR)
            
           titleLabels.append(titLable)
            
            
        }
    }
    //设置底部的线
    private func setBottomScrollLine(){
        
        let bottomLine = UIView()
        bottomLine.backgroundColor=UIColor.lightGray
        bottomLine.frame=CGRect(x: 0, y: frame.height-0.5, width:frame.width , height: kScrollLineH)
        addSubview(bottomLine)
        //取出来第一个lable
        guard let labelFirst = titleLabels.first else {return}
        labelFirst.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        //设置滑动的scrollLine的属性
        scrollV.addSubview(bottomScrollLine)
        bottomScrollLine.frame = CGRect(x: labelFirst.frame.origin.x, y:frame.height - kScrollLineH, width: labelFirst.frame.width, height: kScrollLineH)
    }
}
//MARK:--监听lable 的点击
extension PageTitleView {

    @objc private func titleLabelCheck (tapGR : UITapGestureRecognizer) {
        
        //1.获取点击lable
        guard let tapLable = tapGR.view as? UILabel  else { return }
        tapLable.textColor = UIColor.orange
        
        //2.之前的lable
        let oldLabel = titleLabels[currentIndex]
        
        //3.更改文字颜色
        tapLable.textColor = UIColor.orange
        oldLabel.textColor = UIColor.darkGray
        
        //4.滚动条儿滚动事件
        let currentLableX = CGFloat(tapLable.tag) * tapLable.frame.width
        UIView.animate(withDuration: 0.2) {
            self.bottomScrollLine.frame.origin.x = currentLableX
        }
        
        //记录现在的label 的index
        currentIndex = tapLable.tag
        
        //5.通知代理
        delegate?.pageTitleViewClickTitle(pageTitleV: self, clickIndex: currentIndex)
    }
}
//MARK: -- 对外暴露方法
extension PageTitleView {
    func titleViewScroll (progress:CGFloat , oldIndex:Int , changedIndex:Int){
        //1.获取到原，现的label
        let oldLable = titleLabels[oldIndex]
        let newLabel = titleLabels[changedIndex]
        //2.移动下面的线
        let moveTotalX = newLabel.frame.origin.x - oldLable.frame.origin.x
        let moveX   =  moveTotalX * progress
        bottomScrollLine.frame.origin.x = oldLable.frame.origin.x + moveX
        
        //3.颜色渐变
        // 3.1 取出颜色变化范围
        let colorDelte = (kSelectedColor.0 - kNormalColor.0,kSelectedColor.1 - kNormalColor.1,kSelectedColor.2 - kNormalColor.2)
        //3.2 变化oldlabel 的颜色
        oldLable.textColor = UIColor(r: kSelectedColor.0 - colorDelte.0 * progress, g: kSelectedColor.1 - colorDelte.1 * progress, b: kSelectedColor.2 - colorDelte.2 * progress)
        //3.2 变化 new Label 的颜色
        newLabel.textColor =  UIColor(r: kNormalColor.0 + colorDelte.0 * progress, g: kNormalColor.1 + colorDelte.1 * progress, b: kNormalColor.2 + colorDelte.2 * progress)
        
        if oldIndex == changedIndex && progress == 0.0 { //代表没滑动过去
            for label in titleLabels {
                label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            }
            newLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        }
        
        //记录当前index
        currentIndex = changedIndex
    }
}
