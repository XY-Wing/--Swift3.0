//
//  WingCollectionViewCell.swift
//  流水布局
//
//  Created by Wing on 16/10/9.
//  Copyright © 2016年 Wing. All rights reserved.
//

import UIKit

class WingCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        
        let L = UILabel()
        L.backgroundColor = UIColor.clear
        return L
    }()
    
    lazy var imageV: UIImageView = {
    
        let imgV: UIImageView = UIImageView()
    
        let i = arc4random_uniform(4) + 1
        
//        imgV.image = UIImage(named: "\(i).jpeg")
        imgV.image = UIImage(named: "4.jpeg")
        return imgV
    }()
    /**
     初始化
     *
     */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(){
        
        contentView.addSubview(imageV)
        contentView.addSubview(label)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        label.sizeToFit()
        
        imageV.frame = self.bounds
    }
}
