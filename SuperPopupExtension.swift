//
//  SuperPopupExtension.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation

public extension UIView{
    
    // 创建一个动画组壳
    func spAnimationGroup() -> CAAnimationGroup {
        let group:CAAnimationGroup = CAAnimationGroup.init()
        group.duration = 1
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        group.autoreverses = false
        group.fillMode = kCAFillModeBoth
        group.animations = [CAAnimation]()
        return group
    }
    
    
    // 根据滑动类型计算滑动的值
    func calculatePosition(slideDirection:SPSlideDirection,show:Bool = true) -> CGPoint{
        let halfw:CGFloat = self.frame.size.width * 0.5
        let halfh:CGFloat = self.frame.size.height * 0.5
        
        let superw = self.superview?.frame.size.width ?? sbw
        let superh = self.superview?.frame.size.height ?? sbh
        
        var point = CGPoint.init(x: halfw, y: halfh)
        if slideDirection == .fromLeft {
            if show {
                point = CGPoint.init(x: -halfw, y: superh * 0.5)
            }else{
                point = CGPoint.init(x: halfw, y: superh * 0.5)
            }
        }else if slideDirection == .fromBottom {
            if show {
                point = CGPoint.init(x: superw * 0.5, y: superh + halfh)
            }else{
                point = CGPoint.init(x: superw * 0.5, y: superh - halfh)
            }
        }else if slideDirection == .fromRight {
            if show {
                point = CGPoint.init(x: superw + halfw, y: superh * 0.5)
            }else{
                point = CGPoint.init(x: superw - halfw, y: superh * 0.5)
            }
        }else if slideDirection == .fromTop {
            if show {
                point = CGPoint.init(x: superw * 0.5, y: -halfh)
            }else{
                point = CGPoint.init(x: superw * 0.5, y: halfh)
            }
        }else{
            point = CGPoint.init(x: halfw, y: halfh)
        }
        return point
    }
    
    
    
    // 根据折叠类型计算折叠的值
    func calculateFold(targetSize:CGSize,unfoldDirection:SPUnfoldDirection,show:Bool = true) -> CGRect{
        
        let ss = targetSize
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        var w:CGFloat = 0.0
        var h:CGFloat = 0.0
        if show {
            x = 0
            y = 0
            w = ss.width
            h = ss.height
        }else{
            if unfoldDirection == .toLeftBottom {
                x = ss.width
                y = 0
                w = 0
                h = 0
            }else if unfoldDirection == .toLeft {
                x = ss.width
                y = 0
                w = 0
                h = ss.height
            }else if unfoldDirection == .toLeftTop {
                x = ss.width
                y = ss.height
                w = 0
                h = 0
            }else if unfoldDirection == .toTop {
                x = 0
                y = ss.height
                w = ss.width
                h = 0
            }else if unfoldDirection == .toRightTop {
                x = 0
                y = ss.height
                w = 0
                h = 0
            }else if unfoldDirection == .toRight {
                x = 0
                y = 0
                w = 0
                h = ss.height
            }else if unfoldDirection == .toRightBottom {
                x = 0
                y = 0
                w = 0
                h = 0
            }else if unfoldDirection == .toBottom {
                x = 0
                y = 0
                w = ss.width
                h = 0
            }
        }
        
        return CGRect.init(x: x, y: y, width: w, height: h)
    }
}
