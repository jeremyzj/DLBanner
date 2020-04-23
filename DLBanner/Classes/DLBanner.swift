//
//  DLBanner.swift
//  Deeplearning
//
//  Created by magi on 2020/4/23.
//  Copyright © 2020 magi. All rights reserved.
//

import UIKit
import Kingfisher

public enum DLBannerStyle {
    case none
    case card
    case swiper
}


public typealias DLdidSelectItemAtIndexClosure = (IndexPath) -> Void
public typealias DLdidScrollToIndexClosure = (Int) -> Void

public class DLBanner: UIView {
    
    // MARK: 样式
    public var style: DLBannerStyle = .card
    public var itemSize: CGSize = CGSize.zero {
        didSet {
            layout?.itemSize = CGSize(width: itemSize.width, height: itemSize.height)
        }
    }
    public var isNeedShadow: Bool = true
    public var minimumLineSpacing: CGFloat = 8.0
    public var cornerRadius: CGFloat = 0
    public var needIndicator: Bool = true
    
    // MARK: 数据
    var totalItemsCount: Int?
    public var imagePaths: Array<String> = [] {
        didSet {
            innerImagePaths = imagePaths + imagePaths
            
            if let itemCount = innerImagePaths?.count, itemCount > 1 {
                collectionView?.isScrollEnabled = true
                collectionView?.reloadData()
                collectionView?.scrollToItem(at: IndexPath(item: itemCount / 2, section: 0),
                                                  at: .centeredHorizontally,
                                                  animated: false)
                self.reloadIndicator(imageUrls: imagePaths)
            } else {
                collectionView?.isScrollEnabled = false
            }
            
        }
    }
    private var innerImagePaths: Array<String>?
    
    // MARK: 回调
    public var dlDidSelectItemAtIndex: DLdidSelectItemAtIndexClosure?
    public var dlScrollToIndex : DLdidScrollToIndexClosure?
    
    // MARK: 布局
    var collectionView: UICollectionView?
    public var layout: DLLayout?
    var indicator: UIView?
    var currentIndicator: UIView?
    var swiperLayout: UICollectionViewFlowLayout?

    func setUpCollection() {
        
        layout = DLLayout()
        layout?.minimumSpacing = minimumLineSpacing
        
        let rect = self.bounds
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout!)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.bounces = false
        collectionView?.register(DLBannerCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.9)
        self.addSubview(collectionView!)
        self.setUpIndicator()
    }
    
    func setUpSwiperCollection() {
        
        let swiperlayout = UICollectionViewFlowLayout()
        swiperlayout.scrollDirection = .horizontal
        swiperlayout.minimumLineSpacing = 0
        swiperlayout.itemSize = self.bounds.size
        self.swiperLayout = swiperlayout
        
        let rect = self.bounds
        collectionView = UICollectionView(frame: rect, collectionViewLayout: swiperlayout)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.bounces = false
        collectionView?.register(DLBannerCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.clear

        collectionView?.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.9)
        self.addSubview(collectionView!)
        
        self.setUpIndicator()
    }

}


extension DLBanner: UICollectionViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        guard let imgUrlCount = self.innerImagePaths?.count else {
            return
        }
        
        if (offset == 0) {
            self.collectionView?.scrollToItem(at: IndexPath(item: imgUrlCount / 2, section: 0),
                                              at: .centeredHorizontally,
                                              animated: false)
        } else if (offset == scrollView.contentSize.width - self.frame.size.width) {
            self.collectionView?.scrollToItem(at: IndexPath(item: imgUrlCount / 2 - 1, section: 0),
                                              at: .centeredHorizontally,
                                              animated: false)
        }
        
        let index = self.indexOfMajorCell()
        if let hander = dlScrollToIndex {
            hander(index)
        }
        self.resetCurrentIndicator(index)
        
    }
    
    private func indexOfMajorCell() -> Int {
        let flowlayout = self.style == .swiper ? self.swiperLayout : self.layout
        guard let layout = flowlayout,
            let collectionView = layout.collectionView,
            let imageUrl = self.innerImagePaths
        else {
            return 0
        }
        let itemWidth = layout.itemSize.width
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(imageUrl.count - 1, index))
        return safeIndex
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let hander = dlDidSelectItemAtIndex {
            hander(indexPath)
        }
    }
}

extension DLBanner: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.innerImagePaths?.count ?? 0
    }
       
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DLBannerCell
        if let imageUrl = self.innerImagePaths?[indexPath.item] {
            cell.isNeedShadow = isNeedShadow
            cell.cornerRadius = cornerRadius
            cell.imgView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "BannerPlaceholder"))
        }
        return cell
    }
    
}

extension DLBanner {
    /// 默认初始化
    ///
    /// - Parameters:
    ///   - frame: Frame
    ///   - imageURLPaths: URL Path Array
    ///   - titles: Title Array
    ///   - didSelectItemAtIndex: Closure
    /// - Returns: DLBanner
    public class func dlCardBanner(_ frame: CGRect, imageURLPaths: Array<String>? = []) -> DLBanner {
        let dlBanner: DLBanner = DLBanner(frame: frame)
        dlBanner.imagePaths = []
        dlBanner.style = .card
        
        if let imageURLPathList = imageURLPaths, imageURLPathList.count > 0 {
            dlBanner.imagePaths = imageURLPathList
        }
        
        dlBanner.setUpCollection()
        
        return dlBanner
    }
    
    public class func dlSwiperBanner(_ frame: CGRect) -> DLBanner {
        let dlBanner: DLBanner = DLBanner(frame: frame)
        dlBanner.imagePaths = []
        dlBanner.style = .swiper
        
        dlBanner.setUpSwiperCollection()
        
        return dlBanner
    }
}


// MARK:Indicator
let kIndicatorHeight: CGFloat = 25
let kIndicatorItemSize: CGSize = CGSize(width: 5, height: 5)
let kIndicatorSpace: CGFloat = 12

extension DLBanner {
    
    func setUpIndicator () {
        if !needIndicator {
            return
        }
        let indicates = UIView(frame: CGRect(x: 0,
                                             y: Int(self.bounds.height) - Int(kIndicatorHeight),
                                             width: Int(self.bounds.width),
                                             height: Int(kIndicatorHeight)))
        indicates.isUserInteractionEnabled = false
        self.addSubview(indicates)
        self.indicator = indicates
    }
    
    func reloadIndicator(imageUrls: Array<String>) {
        if !needIndicator {
            return
        }
        var xIndex = 0
        let itemWidth: CGFloat = kIndicatorItemSize.width
        let itemHeight: CGFloat = kIndicatorItemSize.height
        let imageCount = imageUrls.count
        let indicateWidth: CGFloat = (itemWidth * CGFloat(imageCount)) + kIndicatorSpace * CGFloat(imageCount - 2)
        let startIndicate: CGFloat = (CGFloat(self.bounds.width) - indicateWidth) / 2.0
        let eachSpace: CGFloat = itemWidth + kIndicatorSpace
        for _ in imageUrls {
            let indicator = UIView(frame: CGRect(x: startIndicate + CGFloat(xIndex) * eachSpace, y: 10, width: itemWidth, height: itemHeight))
            indicator.backgroundColor = UIColor.rgba(r: 255.0, g: 255.0, b: 255.0, a: 0.5)
            indicator.layer.cornerRadius = itemHeight / 2
            indicator.layer.masksToBounds = true
            self.indicator?.addSubview(indicator)
            xIndex += 1
        }
        self.loadCurrentIndicator(x: startIndicate - 6)
    }
    
    func loadCurrentIndicator(x: CGFloat) {
        if !needIndicator {
            return
        }
        let eachSpace: CGFloat = kIndicatorItemSize.width + kIndicatorSpace
        let itemHeight: CGFloat = kIndicatorItemSize.height
        let indicator = UIView(frame: CGRect(x:x , y: 10, width: eachSpace, height: kIndicatorItemSize.height))
        indicator.backgroundColor = UIColor.rgba(r: 255.0, g: 255.0, b: 255.0, a: 1)
        indicator.layer.cornerRadius = itemHeight / CGFloat(2)
        indicator.layer.masksToBounds = true
        self.indicator?.addSubview(indicator)
        self.currentIndicator = indicator
    }
    
    func resetCurrentIndicator(_ index: Int) {
        if !needIndicator {
            return
        }
        guard let imageUrls = self.innerImagePaths else {
            return
        }
        let itemWidth: CGFloat = kIndicatorItemSize.width
        let itemHeight: CGFloat = kIndicatorItemSize.height
        
        let count = imageUrls.count / 2
        let currentX = CGFloat(index % count) * (itemWidth + kIndicatorSpace)
        let indicateWidth = itemWidth * CGFloat(count) + kIndicatorSpace * CGFloat(count - 2)
        let startIndicate = (CGFloat(self.bounds.size.width) - CGFloat(indicateWidth)) / 2.0 - 6
        self.currentIndicator?.frame = CGRect(x: currentX + startIndicate,
                                              y: 10,
                                              width: itemWidth + kIndicatorSpace,
                                              height: itemHeight)
    }
}
