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
    }
    
    var showed:Bool = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.blockView.layer.add(self.view.spAlphaAnimation(), forKey: "opacity")
           
        if self.showed{
            self.blockView.sphide.spScaleAnimation { (param) in
                
            }.finish()
        }else{
            self.blockView.spshow.spScaleAnimation { (param) in
                
            }.finish()
        }
        self.showed = !self.showed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

