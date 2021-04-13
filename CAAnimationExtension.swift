//
//  CAAnimationExtension.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation


public extension CAAnimation{
  
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
    static func spScaleAnimation(values:[Double],duration:Double = 0.25) -> CAKeyframeAnimation{
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
    
    /// 形变-仅可用于CAShapeLayer
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
