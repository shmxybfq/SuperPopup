//
//  SuperPopup.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation

// 封装动画类型
public enum SPPopupType : Int, Codable{
    case none = 0
    case alpha
    case slide
    case scale
    case fold
    case bubble
    case mask
    case other
}

// 基础动画类型
public enum SPBaseAnimationType : Int, Codable{
    case none = 0
    case opacity
    case position
    case size
    case scale
    case rotation
}

// 旋转类型
public enum SPRotationType : Int, Codable{
    case none = 0
    case x
    case y
    case z
}


// 旋转类型
public enum SPStepType : Int, Codable{
    case none = 0
    case show
    case hide
}

// 滑动方向
public enum SPSlideDirection : Int, Codable{
    case none = 0
    case fromLeft
    case fromBottom
    case fromRight
    case fromTop
}

// 折叠展开方向
public enum SPUnfoldDirection : Int, Codable{
    case none = 0
    case toLeftBottom
    case toLeft
    case toLeftTop
    case toTop
    case toRightTop
    case toRight
    case toRightBottom
    case toBottom
}

public let sb: CGRect = UIScreen.main.bounds

public let sbs: CGSize = sb.size
public let sbw: CGFloat = sb.size.width
public let sbh: CGFloat = sb.size.height

public extension UIView{
    
    var spparam:SPParam?{
        get{
            return SPParam.init()
        }
    }
    
    func sp_show(type:SPPopupType = .none,
                 slideDirection:SPSlideDirection = .fromBottom){
        
        print("self.layer.anchorPoint:\(self.layer.anchorPoint)")
//        self.layer.anchorPoint = CGPoint.init(x: 0.0, y: 0.0)
        self.setAnchorPoint(point: CGPoint.init(x: 1.0, y: 0.5), forView: self)
        
        if type == .alpha {
            self.layer.add(self.packageAlphaAnimation(step: .show), forKey: "show_alpha")
        }else if type == .slide {
            self.layer.add(self.packageSlideAnimation(step: .show, slideDirection: slideDirection), forKey: "show_slide")
        }else if type == .scale {
            self.layer.add(self.packageScaleAnimation(step: .show,spring: false), forKey: "show_scale")
        }else if type == .fold {
            var shapeLayer = CAShapeLayer.init()
            if let shape = self.layer.mask{
                shapeLayer = shape as! CAShapeLayer
            }else{
                self.layer.mask = shapeLayer
            }
            shapeLayer.path = UIBezierPath.init(rect: self.calculateFold(targetSize: self.frame.size, unfoldDirection: .toBottom, show: true)).cgPath
            shapeLayer.add(self.packageFoldAnimation(step: .show,unfoldDirection: .toBottom), forKey: "show_fold")
        }else if type == .bubble {
            
        }else if type == .mask {
            
        }
        
    }
    
    //彻底理解position与anchorPoint
    //https://www.cnblogs.com/benbenzhu/p/3615516.html
    func setAnchorPoint(point:CGPoint,forView:UIView){
        let oldFrame = forView.frame
        forView.layer.anchorPoint = point
        forView.frame = oldFrame
    }
    
    func sp_hide(type:SPPopupType = .none,
                 slideDirection:SPSlideDirection = .fromBottom){
        
        if type == .alpha {
            self.layer.add(self.packageAlphaAnimation(step: .hide), forKey: "show_alpha")
        }else if type == .slide {
            self.layer.add(self.packageSlideAnimation(step: .hide, slideDirection: slideDirection), forKey: "show_slide")
        }else if type == .scale {
            self.layer.add(self.packageScaleAnimation(step: .hide,spring: false), forKey: "show_scale")
        }else if type == .fold {
            var shapeLayer = CAShapeLayer.init()
            if let shape = self.layer.mask{
                shapeLayer = shape as! CAShapeLayer
            }else{
                self.layer.mask = shapeLayer
            }
            shapeLayer.add(self.packageFoldAnimation(step: .hide,unfoldDirection: .toBottom), forKey: "show_fold")
        }else if type == .bubble {
            
        }else if type == .mask {
            
        }
    }

    // 打包 bubble 封装动画类型
    func packageBubbleAnimation(step:SPStepType,unfoldDirection:SPUnfoldDirection = .toBottom) -> CAAnimationGroup {

        let group:CAAnimationGroup = self.spAnimationGroup()
//
//        var from:CGRect = CGRect.zero
//        var to:CGRect = CGRect.zero
//
//        if step == .show {
//            from = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: false)
//            to = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: true)
//        }else if step == .hide{
//            from = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: true)
//            to = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: false)
//        }
//        let fromPath = UIBezierPath.init(rect: from)
//        let toPath = UIBezierPath.init(rect: to)
//        let ani = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: 1)
//        group.animations?.append(ani)
//
        return group
    }
    
    // 打包 fold 封装动画类型
    func packageFoldAnimation(step:SPStepType,unfoldDirection:SPUnfoldDirection = .toBottom) -> CAAnimationGroup {
        
        let group:CAAnimationGroup = self.spAnimationGroup()
        
        var from:CGRect = CGRect.zero
        var to:CGRect = CGRect.zero

        if step == .show {
            from = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: false)
            to = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: true)
        }else if step == .hide{
            from = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: true)
            to = self.calculateFold(targetSize: self.frame.size, unfoldDirection: unfoldDirection, show: false)
        }
        let fromPath = UIBezierPath.init(rect: from)
        let toPath = UIBezierPath.init(rect: to)
        let ani = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: 1)
        group.animations?.append(ani)

        return group
    }
    
    
    // 打包 scale 封装动画类型
    func packageScaleAnimation(step:SPStepType,spring:Bool = false) -> CAAnimationGroup {
        self.setAnchorPoint(point: CGPoint.init(x: 0.5, y: 0.5), forView: self)
        let group:CAAnimationGroup = self.spAnimationGroup()
        if spring {
            var values:[Double] = []
            values.append(0.0)
            values.append(1.2)
            values.append(0.9)
            values.append(1.0)
            if step == .hide {
                values.reverse()
            }
            let ani = CAAnimation.spScaleAnimation(values: values, duration: 1)
            group.animations?.append(ani)

        }else{
            var from:Double = 1.0
            var to:Double = 1.0
            if step == .show {
                from = 0.0
                to = 1.0
            }else if step == .hide{
                from = 1.0
                to = 0.0
            }
            let ani = CAAnimation.spScaleAnimation(values: [from,to], duration: 1)
            group.animations?.append(ani)
        }
        
        return group
    }
    
    
    
    // 打包 slide 封装动画类型
    func packageSlideAnimation(step:SPStepType,slideDirection:SPSlideDirection) -> CAAnimationGroup {
        
        let group:CAAnimationGroup = self.spAnimationGroup()
        
        var from:CGPoint = CGPoint.zero
        var to:CGPoint = CGPoint.zero

        if step == .show {
            from = self.calculatePosition(slideDirection: slideDirection, show: true)
            to = self.calculatePosition(slideDirection: slideDirection, show: false)
        }else if step == .hide{
            from = self.calculatePosition(slideDirection: slideDirection, show: false)
            to = self.calculatePosition(slideDirection: slideDirection, show: true)
        }
        let ani = CAAnimation.spPositionAnimation(values: [from,to], duration: 1)
        group.animations?.append(ani)
        
        return group
    }
    
    
    
    
    // 打包 alpha 封装动画类型
    func packageAlphaAnimation(step:SPStepType) -> CAAnimationGroup {
        let group:CAAnimationGroup = self.spAnimationGroup()
        var from:CGFloat = 1
        var to:CGFloat = 1
        if step == .show {
            from = 0.0
            to = 1.0
        }else if step == .hide{
            from = 0.0
            to = 1.0
        }
        let ani = CAAnimation.spOpacityAnimation(values: [from,to], duration: 1)
        group.animations?.append(ani)
        return group
        
    }
    

}

