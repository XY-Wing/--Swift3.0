//
//  WingWaterFlowLayout.swift
//  流水布局
//
//  Created by Wing on 16/10/8.
//  Copyright © 2016年 Wing. All rights reserved.
//

import UIKit
//MARK: --- 常量
/** 列数 */
private let columnCount: Int = 3
/** 行边距 */
private let columnRowMargin: CGFloat = 10
/** 列边距 */
private let columnMargin: CGFloat = 10
/** item的edgeInsets */
private let itemEdgeInsets: UIEdgeInsets = {
    return UIEdgeInsetsMake(10, 10, 10, 10)
}()


//MARK: --- 代理
@objc protocol WingWaterFlowLayoutDelegate: NSObjectProtocol
{
    
  @objc optional func numberOfColumsForWaterLayout(_ waterFlowLayout: WingWaterFlowLayout) -> Int
  @objc optional func rowMarginForWaterLayout(_ waterFlowLayout: WingWaterFlowLayout) -> CGFloat
  @objc optional func columnMarginForWaterLayout(_ waterFlowLayout: WingWaterFlowLayout) -> CGFloat
}

class WingWaterFlowLayout: UICollectionViewLayout {

    weak var delegate: WingWaterFlowLayoutDelegate?
    
    //MARK: --- 代理 基本外部数据处理
    
    /**
     列数
     *
     */

    func numberOfColumns() -> Int {
        
        let i = delegate?.numberOfColumsForWaterLayout?(self)
        
        guard (i != nil) else
        {
            return columnCount
        }
        return i!
    }
    /**
     行间距
     *
     */

    func rowMargin() -> CGFloat {
        let i = delegate?.rowMarginForWaterLayout?(self)
        guard (i != nil) else
        {
                return columnRowMargin
        }
        return i!
        
    }
    /**
     列间距
     *
     */

    func column2Margin() -> CGFloat {
        let i = delegate?.columnMarginForWaterLayout?(self)
        guard (i != nil) else
        {
            return columnMargin
        }
        return i!
        
    }
    //MARK: --- 懒加载
    /** 存放所有的item的UICollectionViewLayoutAttributes数组 */
    lazy var attrsArray: [UICollectionViewLayoutAttributes] = {
        return Array()
    }()
    /** 存放每一列的最大高度的数组 */
    lazy var columnMaxYArray: [CGFloat] = {
        
        var array = [CGFloat]()
        
        let  numberOfColumns = self.numberOfColumns()
        for i in 0..<numberOfColumns
        {
            array.append(0)
        }
        
        return array
    }()
    
    
    //MARK: --- 内部控制方法
    /** 初始化 */
    override func prepare() {
        super.prepare()
        
        attrsArray.removeAll()
        
        
        //确定item个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        for i in 0..<itemCount
        {
            //拿到item所在的indexPath
            let indexPath = IndexPath(row: i, section: 0)
            
            guard let attrs = layoutAttributesForItem(at: indexPath) else {return}
            attrsArray.append(attrs)
        }
    }
    /** 返回对应rect的item的布局 */
    /** 继承UICollectionViewLayout的子类，该方法会频繁调用 */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
    }
    /** 返回collectionview滚动范围 */
    override var collectionViewContentSize: CGSize
    {
        let h = attrsArray.last!.frame.maxY + rowMargin()
        return CGSize(width: 0, height: h)
    }
    
    /** 返回对应位置的item布局 */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        //创建UICollectionViewLayoutAttributes对象
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //记录高度最小的列高
        var minY = columnMaxYArray[0]
        //记录高度最小的列
        var destinationColumn = 0
        
        for index in 1..<columnMaxYArray.count
        {
            let instance = columnMaxYArray[index]
            
            if instance < minY
            {
                minY = instance
                
                destinationColumn = index
            }
        }
        
        let  numberOfColumns = self.numberOfColumns()
        
        let w: CGFloat = (collectionView!.frame.size.width - itemEdgeInsets.left - itemEdgeInsets.right - (CGFloat(numberOfColumns) - 1) * column2Margin()) / CGFloat(numberOfColumns)
        
        
        let h: CGFloat = 200 + CGFloat(arc4random_uniform(100))
        //item 布局
        let x: CGFloat = column2Margin() + CGFloat(destinationColumn) * (w + column2Margin())
        let y: CGFloat = minY + rowMargin()
        
        attrs.frame = CGRect(x: x, y: y, width: w, height: h)
        
        columnMaxYArray[destinationColumn] = attrs.frame.maxY
        
        return attrs
        
    }

}
