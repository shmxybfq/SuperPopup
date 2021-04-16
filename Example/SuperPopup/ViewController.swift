//
//  ViewController.swift
//  SuperPopup
//
//  Created by shmxybfq@163.com on 04/10/2021.
//  Copyright (c) 2021 shmxybfq@163.com. All rights reserved.
//

import UIKit
import SuperPopup
class ViewController: UIViewController {

    var showed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //1.滑动时offset有问题
    //2.考虑隐藏时动画不同的问题
    //3.缩放动画和spring不能共存
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let param = SPParam.init()
        param.delay = 0
        param.duration = 0.25
        //滑动时有问题
        param.offset = CGPoint.init(x: 0, y: 100)
        
        if self.showed == false{
//            //无
//            self.blockView.spshowIn(self.view).spNoAnimation()

//            //透明度
//            self.blockView.spshowIn(self.view).spAlphaAnimation { (param) in
//                param.to = 0
//            }.finish(param)
            
//            //滑动
//            self.blockView.spshowIn(self.view).spSlideAnimation { (param) in
//                param.slideDirection = .fromRight
//            }.finish(param)
            
//            //缩放
//            self.blockView.spshowIn(self.view).spScaleAnimation { (param) in
//                param.from = 0.0
//                param.to = 0.8
//            }.finish(param)
            
//            //折叠
//            self.blockView.spshowIn(self.view).spFoldAnimation { (param) in
//                param.unfoldDirection = .toTopBottom
//            }.finish(param)
            
            let alert = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as? AlertView
            
            //泡泡
            alert?.spshow(self.view).spBubbleAnimation { (param) in
                
                param.pinPoint = self.view.center
                param.bubbleDirection = .toLeftBottom
                
            }.finish(param)
            
        }else{
          
//            //无
//            self.blockView.sphide.spNoAnimation()
            
//            //透明度
//            self.blockView.sphide.spAlphaAnimation { (param) in
//                param.to = 1
//            }.finish(param)
            
//            //滑动
//            self.blockView.sphide.spSlideAnimation { (param) in
//                param.slideDirection = .fromRight
//            }.finish(param)
            
//            //缩放
//            self.blockView.sphide.spScaleAnimation { (param) in
//                param.from = 0.8
//                param.to = 0.3
//            }.finish(param)
            
            
//            //折叠
//            self.blockView.sphide.spFoldAnimation { (param) in
//                param.unfoldDirection = .toLeftBottom
//            }.finish(param)

            //泡泡
//            self.blockView.sphide.spBubbleAnimation { (param) in
//
//                param.pinPoint = CGPoint.init(x: self.blockView.frame.minX, y: self.blockView.frame.minY + self.blockView.frame.size.height * 0.5)
//                param.bubbleDirection = .toRight
//            }.finish(param)
            
        }
        self.showed = !self.showed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

