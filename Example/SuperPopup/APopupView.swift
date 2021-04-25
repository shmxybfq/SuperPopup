//
//  APopupView.swift
//  SuperPopup_Example
//
//  Created by 成丰快运 on 2021/4/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class APopupView: UIView {
    
    deinit {
        print("释放======")
    }
    
    @IBOutlet weak var imageView: UIImageView!
    var imageName:String? = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public class func creat(_ imgName: String) -> APopupView {
        
        
        let popup = Bundle.main.loadNibNamed("APopupView", owner: self, options: nil)?.first as! APopupView
        popup.tag = 1999
        popup.imageName = imgName
        
        let size = UIScreen.main.bounds.size
        var frame = CGRect.zero
        let ratio = 0.3
        
        if imgName == "popup-1" {
            frame = CGRect.init(x: 0, y: 0, width: 901 * ratio, height: 927 * ratio)
        }else if imgName == "popup-2" {
            frame = CGRect.init(x: 0, y: 0, width: 1119 * ratio, height: 670 * ratio)
        }else if imgName == "popup-3" {
            frame = CGRect.init(x: 0, y: 0, width: 1196 * ratio, height: 234 * ratio)
        }else if imgName == "popup-4" {
            frame = CGRect.init(x: 0, y: 0, width: 1062 * ratio, height: 1423 * ratio)
        }else if imgName == "popup-5" {
            frame = CGRect.init(x: 0, y: 0, width: 1242 * ratio, height: 948 * ratio)
        }else if imgName == "popup-6" {
            frame = CGRect.init(x: 0, y: 0, width: 493 * ratio, height: 485 * ratio)
        }else if imgName == "popup-7" {
            frame = CGRect.init(x: 0.0, y: 0.0, width: 1123.0 * (size.height / 2208.0), height: size.height)
        }else if imgName == "popup-8" {
            frame = CGRect.init(x: 0.0, y: 0.0, width: 974.0 * (size.height / 2208.0), height: size.height)
        }else if imgName == "popup-9" {
            frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        }else if imgName == "popup-10" {
            frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        }else if imgName == "popup-11" {
            frame = CGRect.init(x: 0, y: 0, width: 658 * ratio, height: 969 * ratio)
        }else if imgName == "popup-bg-1" {
            frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        }else if imgName == "popup-bg-2" {
            frame = CGRect.init(x: 0, y: 0, width: 670.0 / (502.0 / size.width), height: size.width)
        }else if imgName == "popup-bg-3" {
            frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        }else if imgName == "share_friend" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }else if imgName == "share_link" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }else if imgName == "share_message" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }else if imgName == "share_qq_zone" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }else if imgName == "share_qq" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }else if imgName == "share_weibo" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }else if imgName == "share_weixin" {
            frame = CGRect.init(x: 0, y: 0, width: 120 * ratio, height: 120 * ratio)
        }
        
        popup.frame = frame
        popup.center = CGPoint.init(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5)
        popup.imageView.image = UIImage.init(named: imgName)
        
        return popup
    }
    
    
    override func backgroundTouch(_ spview: UIView, _ background: UIView) -> Bool {
        return false
    }

}
