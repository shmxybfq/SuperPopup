//
//  CAAnimationExtension.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation

private var kAnimationTagKey: Void?
private var kAnimationValueKey: Void?

public extension CAAnimation{
  
    
    var bindTag:String?{
        get {
            return  objc_getAssociatedObject(self, &kAnimationTagKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &kAnimationTagKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    var bindValue:Any?{
        get {
            return objc_getAssociatedObject(self, &kAnimationValueKey)
        }
        set {
            objc_setAssociatedObject(self, &kAnimationValueKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 透明度
    static func spOpacityAnimation(values:[CGFloat],duration:Double = 0.25) -> CAKeyframeAnimation{
        let ani = CAKeyframeAnimation.init()
        ani.keyPath = "opacity"
        ani.values = values
        ani.duration = duration
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        ani.autoreverses = false
        ani.fillMode = kCAFillModeBoth
        return ani
    }
    
    
    /// 位移
    static func spPositionAnimation(values:[CGPoint],duration:Double = 0.25) -> CAKeyframeAnimation{
        let ani = CAKeyframeAnimation.init()
        ani.keyPath = "position"
        ani.values = values
        ani.duration = duration
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        ani.autoreverses = false
        ani.fillMode = kCAFillModeBoth
        
        return ani
    }
    
    /// 尺寸
    static func spSizeAnimation(values:[CGSize],duration:Double = 0.25) -> CAKeyframeAnimation{
        let ani = CAKeyframeAnimation.init()
        ani.keyPath = "bounds.size"
        ani.values = values
        ani.duration = duration
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        ani.autoreverses = false
        ani.fillMode = kCAFillModeBoth
        
        return ani
    }
    
    
    /// 缩放
    static func spScaleAnimation(values:[CGFloat],duration:Double = 0.25) -> CAKeyframeAnimation{
        let ani = CAKeyframeAnimation.init()
        ani.keyPath = "transform.scale"
        ani.values = values
        ani.duration = duration
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        ani.autoreverses = false
        ani.fillMode = kCAFillModeBoth
        return ani
    }
    
    /// 旋转
    static func spRotationAnimation(rotationType:SPRotationType = .z,values:[Double],duration:Double = 0.25) -> CAKeyframeAnimation{
        let ani = CAKeyframeAnimation.init()
        ani.keyPath = "transform.rotation.\(rotationType.description)"
        if rotationType == .none {
            ani.keyPath = "transform.rotation"
        }
        ani.values = values
        ani.duration = duration
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        ani.autoreverses = false
        ani.fillMode = kCAFillModeBoth
        return ani
    }
    
    /// 形变-CAShapeLayer
    static func spPathAnimation(values:[UIBezierPath],duration:Double = 0.25) -> CAKeyframeAnimation{
        let ani = CAKeyframeAnimation.init()
        ani.keyPath = "path"
        var vs:[Any] = []
        for (_,path) in values.enumerated() {
            vs.append(path.cgPath)
        }
        ani.values = vs
        ani.duration = duration
        ani.isRemovedOnCompletion = false
        ani.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        ani.autoreverses = false
        ani.fillMode = kCAFillModeBoth
        return ani
    }
    
    
}
