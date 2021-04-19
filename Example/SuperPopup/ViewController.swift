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
    
    let alert = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as? AlertView

    
    override func viewDidLoad() {
        super.viewDidLoad()
      

    }
    
    //1.滑动时offset有问题
    //2.考虑隐藏时动画不同的问题
    //3.缩放动画和spring不能共存
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let param = SPParam.init()
        param.delay = 0
        param.duration = 1
        param.backgroundView = nil
        //滑动时有问题
        param.offset = CGPoint.init(x: 0, y: -(UIScreen.main.bounds.size.height - 200.0) * 0.5)
        
        if self.showed == false{

//            //滑动
//            alert?.spshow(self.view).spSlideAnimation { (param) in
//                param.slideDirection = .toTop
//            }.finish(param)
            
            alert?.spshow(self.view).spRotationAnimation({ (param) in
                param.rotationType = .z
            }).spRotationAnimation({ (param) in
                param.rotationType = .x
            }).spRotationAnimation({ (param) in
                param.rotationType = .y
            }).spScaleAnimation({ (param) in
                
            }).spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }else{
          
//            //滑动
//            alert?.sphide.spSlideAnimation({ (param) in
//                param.slideDirection = .toTop
//                param.to = CGPoint.init(x: self.alert?.center.x ?? 0, y: (self.alert?.center.y ?? 0) - 200)
//            }).spAlphaAnimation({ (param) in
//                param.to = 0.0
//            }).spScaleAnimation({ (param) in
//                param.to = 0.0
//                param.target?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
//            }).finish(param)
            
            alert?.sphide.spRotationAnimation({ (param) in
                param.rotationType = .z
            }).spRotationAnimation({ (param) in
                param.rotationType = .x
            }).spRotationAnimation({ (param) in
                param.rotationType = .y
            }).spScaleAnimation({ (param) in
                
            }).spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }
        
        self.showed = !self.showed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

