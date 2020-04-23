//
//  ViewController.swift
//  DLBanner
//
//  Created by jackincitibank@gmail.com on 04/23/2020.
//  Copyright (c) 2020 jackincitibank@gmail.com. All rights reserved.
//

import UIKit
import DLBanner

class ViewController: UIViewController {
    
    var itemWidth : CGFloat {
        get {
            return self.view.frame.size.width - 40
        }
    }
    var itemHeight : CGFloat {
        get {
            return (175 / 335) * itemWidth
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBanner()
    }
    
    func setupBanner() {
        
        let rect = CGRect(x: 0, y: 100, width:self.view.frame.size.width, height: itemHeight)
        let dlBanner = DLBanner.dlCardBanner(rect)
        dlBanner.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let bannerImg1 = "https://m.tuniucdn.com/filebroker/cdn/olb/24/a1/24a13f1acbc9d5094a6fddad9d2be15c_w800_h0_c0_t0.jpg"
        let bannerImg2 = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3869197645,3577495116&fm=15&gp=0.jpg"
        let bannerImg3 = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1496226470,2589120333&fm=26&gp=0.jpg"
        let bannerImg4 = "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1634560202,1156081058&fm=26&gp=0.jpg"
        
        let imageUrls: Array<String> = [bannerImg1, bannerImg2, bannerImg3, bannerImg4]
        dlBanner.imagePaths = imageUrls
        
        self.view.addSubview(dlBanner)
        
        let dlswiperBanner = DLBanner.dlSwiperBanner(CGRect(x: 0, y: 300, width:self.view.frame.size.width, height: itemHeight))
        dlswiperBanner.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        dlswiperBanner.imagePaths = imageUrls
        
        self.view.addSubview(dlswiperBanner)
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

