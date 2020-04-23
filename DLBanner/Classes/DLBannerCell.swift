//
//  DLBannerCell.swift
//  Deeplearning
//
//  Created by magi on 2020/4/23.
//  Copyright © 2020 magi. All rights reserved.
//

import UIKit

class DLBannerCell: UICollectionViewCell {
    var imgView:UIImageView!
    var isNeedShadow: Bool = true
    var cornerRadius: CGFloat = 0
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        let backView = UIView(frame:contentView.bounds)
        addSubview(backView)
        if isNeedShadow {
            backView.layer.shadowOpacity = 0.08
            backView.layer.shadowColor = UIColor.black.cgColor
            backView.layer.shadowOffset = CGSize(width: 10, height: 10)
            backView.layer.shadowRadius = 3
        }

        imgView = UIImageView(frame:contentView.bounds)
        if cornerRadius > 0 {
            imgView.layer.cornerRadius = 10
            imgView.layer.masksToBounds = true
        }
        backView.addSubview(imgView)

        contentView.addSubview(backView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
