//
//  SuppleView.swift
//  FanCollectionViewFlowlayout
//
//  Created by 向阳凡 on 16/3/28.
//  Copyright © 2016年 凡向阳. All rights reserved.
//
import UIKit

class SuppleView: UICollectionReusableView {
    var titleLabel:UILabel?
    override func awakeFromNib() {
        titleLabel=UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 20))
        self.addSubview(titleLabel!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel=UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 20))
        self.addSubview(titleLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
