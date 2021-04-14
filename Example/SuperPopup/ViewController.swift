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

    @IBOutlet weak var blockView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blockView.alpha = 1
        self.showed = false
    }
    
    var showed:Bool = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.blockView.layer.add(self.view.spAlphaAnimation(), forKey: "opacity")
        let param = SPParam.init()
        param.delay = 0
        param.duration = 1
        if self.showed{
//            self.blockView.sphide.spScaleAnimation { (param) in
//                param.spring = true
//            }.finish()
            
//            self.blockView.sphide.spSlideAnimation { (param) in
//
//            }.finish(param)
            
            
//            self.blockView.sphide.spNoAnimation()
            
            self.blockView.sphide.spFoldAnimation { (param) in
                
            }.finish(param)
            
        }else{


//            self.blockView.spshow.spScaleAnimation { (param) in
//
//            }.finish()
            
          
//            self.blockView.spshow.spSlideAnimation { (param) in
//
//            }.finish(param)
            
//            self.blockView.spshow.spNoAnimation()
            
            self.blockView.spshow.spFoldAnimation { (param) in
                
            }.finish(param)
        }
        self.showed = !self.showed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

