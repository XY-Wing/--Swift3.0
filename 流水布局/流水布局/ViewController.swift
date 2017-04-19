//
//  ViewController.swift
//  流水布局
//
//  Created by Wing on 16/10/8.
//  Copyright © 2016年 Wing. All rights reserved.
//

import UIKit

let cellIdentifier: String = "waterLayoutCell"

class ViewController: UIViewController {
    
    /**
     记录collectionView的滚动偏移量
     *
     */
    var scrollContentOffsetY: CGFloat = 0
    /**
     是否时向下滑动
     *
     */

    var scrollDown: Bool = true
    
    lazy var collectionView: UICollectionView = {
    
        //建表
        let layout = WingWaterFlowLayout()
        layout.delegate = self
        let c: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        c.backgroundColor = UIColor.white
        c.delegate = self
        c.dataSource = self
        c.register(WingCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        print("一次")
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
//MARK: --- UICollectionViewDelegate,UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource
{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 50
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WingCollectionViewCell
        cell.label.text = "\(indexPath.item)"
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0.2
        if scrollDown == true
        {
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            
            UIView.animate(withDuration: 1) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1;
            }
        }
        else
        {
            cell.transform = CGAffineTransform(translationX: 0, y: -20)
            
            UIView.animate(withDuration: 1) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1;
            }
        }
        
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollDown = scrollView.contentOffset.y - scrollContentOffsetY > 0 ? true : false
        
        scrollContentOffsetY = scrollView.contentOffset.y
    }
}
//MARK: ---  WingWaterFlowLayoutDelegate
extension ViewController: WingWaterFlowLayoutDelegate
{
    func numberOfColumsForWaterLayout(_ waterFlowLayout: WingWaterFlowLayout) -> Int
    {
        return 3
    }
//    func columnMarginForWaterLayout(_ waterFlowLayout: WingWaterFlowLayout) -> CGFloat {
//        return 5
//    }
//    func rowMarginForWaterLayout(_ waterFlowLayout: WingWaterFlowLayout) -> CGFloat {
//        return 5
//    }

}
