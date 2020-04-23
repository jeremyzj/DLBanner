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
    var backView: UIView?
    var isNeedShadow: Bool = false {
        didSet {
            if isNeedShadow {
                backView?.layer.shadowOpacity = 0.08
                backView?.layer.shadowColor = UIColor.black.cgColor
                backView?.layer.shadowOffset = CGSize(width: 10, height: 10)
                backView?.layer.shadowRadius = 3
            }
        }
    }
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            if cornerRadius > 0 {
                imgView.layer.cornerRadius = 10
                imgView.layer.masksToBounds = true
            }
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        let backView = UIView(frame:contentView.bounds)
        addSubview(backView)
        self.backView = backView

        imgView = UIImageView(frame:contentView.bounds)
        backView.addSubview(imgView)

        contentView.addSubview(backView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

