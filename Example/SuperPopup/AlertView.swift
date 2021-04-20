//
//  AlertView.swift
//  SuperPopup_Example
//
//  Created by 成丰快运 on 2021/4/16.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import SuperPopup

class AlertView: UIView {

//    override func backgroundCount(_ spview: UIView) -> Int {
//        return 9
//    }
//    
//    override func backgroundViewForIndex(_ spview: UIView, index: Int) -> UIView {
//        let background = UIButton.init()
//        background.addTarget(self, action: #selector(backgroundxx), for: .touchUpInside)
//        
//        let random0:CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
//        let random1:CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
//        let random2:CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
//        
//        background.backgroundColor = UIColor.init(red: random0, green: random1, blue: random2, alpha: 1)
//        
//        let x = (index) % 3 * Int(UIScreen.main.bounds.size.width / 3.0)
//        let y = (index) / 3 * Int(UIScreen.main.bounds.size.height / 3.0)
//        
//        background.frame = CGRect.init(x: x, y: y, width: Int(UIScreen.main.bounds.size.width / 3.0), height: Int(UIScreen.main.bounds.size.height / 3.0))
//        
//        print(">>>>>>>>>>\(background)")
//        
//        return background
//    }
    
    override func backgroundTouch(_ spview: UIView, _ background: UIView) -> Bool {
        return true
    }
    

    @objc func backgroundxx(){
        
        self.sphide().spSlideAnimation { (param) in
            
        }.finish(SPParam.init(1))
    }
}
