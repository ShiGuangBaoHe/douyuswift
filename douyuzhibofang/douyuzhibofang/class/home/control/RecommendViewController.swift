//
//  RecommendViewController.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/10.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit



private let itemMargin:CGFloat = 10
private let itemW : CGFloat = ( kScreenW - 3 * itemMargin )/2
private let itemNormalH : CGFloat = itemW / 4 * 3
private let itemPrettyH : CGFloat = itemW / 3 * 4
private let itemHeaderH : CGFloat = 50


private let cellID_normal : String = "cellID_normal"
private let cellID_pertty : String = "cellID_pertty"
private let cellID_header : String = "cellID_header"

class RecommendViewController: UIViewController {

    //MARK: -- 懒加载
    private lazy var recommendVM : RecommendViewModel = {
        
        let recommendVM = RecommendViewModel()
        return recommendVM
    }()
    
    private lazy var collectionV : UICollectionView = {[unowned self] in
        //设置layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: itemNormalH)
        layout.minimumLineSpacing = 0 //行间距
        layout.minimumInteritemSpacing = itemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: itemHeaderH)
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        let collectionV = UICollectionView (frame: self.view.bounds, collectionViewLayout: layout)
        collectionV.backgroundColor = UIColor.white
        collectionV.dataSource = self
        collectionV.delegate = self
        //跟着父view 的视图变化而变化
        collectionV.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID_normal)
        //注册头。
        collectionV.register(UINib(nibName:"CollectionHomeNorlReusView" , bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellID_header)
        collectionV.register(UINib(nibName: "CollectionNormalViewCell", bundle: nil), forCellWithReuseIdentifier: cellID_normal)
        collectionV.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: cellID_pertty)
        return collectionV
    }()
    
    //MARK: 系统回调入口函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
    }
}
//MARK: -- 设置界面UI
extension RecommendViewController {
    private func setUI() {
        view.addSubview(collectionV)
    }
}
//MARK: -- 实现 collectionViewDatasource   delegate
extension RecommendViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.recommendVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return self.recommendVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: itemW, height: itemPrettyH)
        }
        
        return CGSize(width: itemW, height: itemNormalH)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        
        if indexPath.section == 1 {
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_pertty, for: indexPath) as! CollectionPrettyCell
            cell.model = anchor
            return cell
        }else {
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID_normal, for: indexPath) as! CollectionNormalViewCell
            cell.model = anchor
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellID_header, for: indexPath) as! CollectionHomeNorlReusView

        reusableView.model = recommendVM.anchorGroups[indexPath.section]
    
        return reusableView
    }
}
//MARK: -- 进行网络加载
extension RecommendViewController {
    private func loadData() {
        recommendVM.requestData {
            self.collectionV.reloadData()
        }
    }
}



