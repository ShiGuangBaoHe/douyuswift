//
//  PageContentView.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/8.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    
    func pageContentViewScrollCollectionEvent(pageContentV : PageContentView, progress : CGFloat, oldIndex : Int , ChangedIndex : Int)
}

private let CELL_ID = "cellId"

class PageContentView: UIView {

    //MARK: 属性
    private var childVCs : [UIViewController]
    private weak var fatherVC : UIViewController?
    private var beginOffsetX : CGFloat = 0
    private var isClickTitle : Bool = false
    weak var delegate : PageContentViewDelegate?
    //MARK: --懒加载
    private lazy var collectionV : UICollectionView = {[weak self] in
        //1.设置layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = (self?.bounds.size)!
        layout.scrollDirection = .horizontal
        //2.设置collectionView
        let collectionV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionV.contentSize = CGSize(width: bounds.width * CGFloat(childVCs.count), height: bounds.height)
        collectionV.isPagingEnabled = true
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.bounces = false  //希望内容不超过view
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        return collectionV
    }()
    //MARK: --init初始化
    init(frame: CGRect , childVCs:[UIViewController] , fatherVC:UIViewController?) {
      
        self.childVCs = childVCs
        self.fatherVC = fatherVC
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: -- 创建UI 视图
extension PageContentView{
    
    private func createUI () {
        //1.把子vc 添加到父vc上
        for vc in childVCs {
            fatherVC?.addChildViewController(vc)
        }
        
        addSubview(collectionV)
        collectionV.frame = bounds
    }
}

//MARK: -- 遵守 UICollectionViewDataSource  Delegate
extension PageContentView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath)
        //因为方法可能循环执行多次，所以最好先清空cell  的 contentView
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childvc = childVCs[indexPath.item]
        childvc.view.frame = cell.contentView.bounds
        cell.contentView.backgroundColor = UIColor.green
        cell.contentView.addSubview(childvc.view)
        
        return cell
    }
    
}
//MARK: -- 遵守 UICollectionView  Delegate
extension PageContentView:UICollectionViewDelegate{
    //开始滑动时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClickTitle = false
        beginOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isClickTitle {return}
        
        var progress : CGFloat = 0//滑动的距离跟屏幕宽的一个比例
        var oldIndex : Int = 0
        var changedIndex : Int = 0
    
        
        let changedOffsetX = scrollView.contentOffset.x
        let itmeW = scrollView.bounds.width
        
        if changedOffsetX >= beginOffsetX {//向左滑动了
            
            progress = ( changedOffsetX / itmeW ) - floor( changedOffsetX / itmeW )
            
            oldIndex = Int ( changedOffsetX/itmeW )
            
            changedIndex = oldIndex + 1
            
            if changedIndex >= childVCs.count {//防止越界
                changedIndex = changedIndex - 1
            }
            //滑过去后
            if changedOffsetX - beginOffsetX == itmeW {
                progress = 1.0
                changedIndex = oldIndex
            }
            
            if changedOffsetX == beginOffsetX {
                progress = 0
                changedIndex = oldIndex
            }
            
           // print(" 向左 ：progress \(progress), oldIndex:\(oldIndex), changedIndex:\(changedIndex)")
            
        }else  if changedOffsetX < beginOffsetX {//向右滑动了
            
            progress = 1 - ( ( changedOffsetX / itmeW ) - floor( changedOffsetX / itmeW ) )
            
            changedIndex = Int( changedOffsetX / itmeW )
            
            oldIndex  = changedIndex + 1
            
            if oldIndex >= childVCs.count {//防止越界
               oldIndex = changedIndex
            }
        
         //   print("向右  :progress \(progress), oldIndex:\(oldIndex), changedIndex:\(changedIndex)")
        }
        
        delegate?.pageContentViewScrollCollectionEvent(pageContentV: self, progress: progress, oldIndex: oldIndex, ChangedIndex: changedIndex)
    }
}
//MARK: -- 对外暴露的方法

extension PageContentView{
    
    func setScrollIndexView (index:Int) {
         isClickTitle = true
        let cOffSet = collectionV.frame.width * CGFloat(index)
        collectionV.setContentOffset(CGPoint(x: cOffSet, y:0 ), animated: false)
    }
}


