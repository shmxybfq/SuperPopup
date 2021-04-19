//
//  SuperPopupExtension.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation

let kSpManagerKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kSpManagerKey".hashValue)
let kSpDataSourceKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kSpDataSourceKey".hashValue)
let kShowAnimationsKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kShowAnimationsKey".hashValue)
let kHideAnimationsKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kHideAnimationsKey".hashValue)
let kEndingKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kEndingKey".hashValue)
let kBackgroundsKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kBackgroundsKey".hashValue)

public extension UIView{
    
    var spManager:SPManager{
        get {
            var spManager = objc_getAssociatedObject(self, kSpManagerKey) as? SPManager
            if spManager == nil {
                spManager = SPManager.init()
                self.spManager = spManager!
            }
            return spManager ?? SPManager.init()
        }
        set {
            objc_setAssociatedObject(self, kSpManagerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var ending:SPEnding?{
        get {
            return objc_getAssociatedObject(self, kEndingKey) as? SPEnding
        }
        set {
            objc_setAssociatedObject(self, kEndingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var shapeLayer:CAShapeLayer{
        get {
            if self.layer.mask == nil{
                self.layer.mask = CAShapeLayer.init()
            }
            return self.layer.mask as! CAShapeLayer
        }
    }
    
    var spDataSource:SPDataSource?{
        get {
            let spDataSource = objc_getAssociatedObject(self, kSpDataSourceKey) as? SPDataSource
            return spDataSource
        }
        set {
            objc_setAssociatedObject(self, kSpDataSourceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var spBackgroundDelegate:SPBackgroundProtocol?{
        get {
            return objc_getAssociatedObject(self, kBackgroundsKey) as? SPBackgroundProtocol
        }
        set {
            objc_setAssociatedObject(self, kBackgroundsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    var showAnimations: Dictionary <String,CAAnimation>{
        get {
            var showAnimations = objc_getAssociatedObject(self, kShowAnimationsKey) as? Dictionary<String,CAAnimation>
            if showAnimations == nil {
                showAnimations = Dictionary <String,CAAnimation>()
                self.showAnimations = showAnimations!
            }
            return showAnimations ?? Dictionary <String,CAAnimation>()
        }
        set {
            objc_setAssociatedObject(self, kShowAnimationsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var hideAnimations: Dictionary <String,CAAnimation>{
        get {
            var hideAnimations = objc_getAssociatedObject(self, kHideAnimationsKey) as? Dictionary<String,CAAnimation>
            if hideAnimations == nil {
                hideAnimations = Dictionary <String,CAAnimation>()
                self.hideAnimations = hideAnimations!
            }
            return hideAnimations ?? Dictionary <String,CAAnimation>()
        }
        set {
            objc_setAssociatedObject(self, kHideAnimationsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    
    // 创建一个动画组壳
    func spAnimationGroup() -> CAAnimationGroup {
        let group:CAAnimationGroup = CAAnimationGroup.init()
        group.duration = 0.25
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        group.autoreverses = false
        group.fillMode = kCAFillModeBoth
        group.animations = [CAAnimation]()
        return group
    }
    
    
    // 根据滑动类型计算滑动的值
    func calculatePosition(_ slideDirection:SPEightDirection,_ step:SPStepType,_ offset:CGPoint) -> (CGPoint,CGPoint){
        
        let selfw:CGFloat = self.frame.size.width
        let selfh:CGFloat = self.frame.size.height
        
        let superw = self.superview?.frame.size.width ?? sbw
        let superh = self.superview?.frame.size.height ?? sbh
        
        var from = CGPoint.init(x: superw * 0.5, y: superh * 0.5)
        var to = CGPoint.init(x: superw * 0.5, y: superh * 0.5)
        
        if step == .show {
            
            if slideDirection == .toTop {
                from = CGPoint.init(x: superw * 0.5 + offset.x, y: superh + selfh)
                to = CGPoint.init(x: superw * 0.5 + offset.x, y: superh - selfh * 0.5 + offset.y)
            }else if slideDirection == .toBottom {
                from = CGPoint.init(x: superw * 0.5 + offset.x, y: -selfh)
                to = CGPoint.init(x: superw * 0.5 + offset.x, y: selfh * 0.5 + offset.y)
            }else if slideDirection == .toRight {
                from = CGPoint.init(x: -selfw, y: superh * 0.5 + offset.y)
                to = CGPoint.init(x: selfw * 0.5 + offset.x, y: superh * 0.5 + offset.y)
            }else if slideDirection == .toLeft {
                from = CGPoint.init(x: superw + selfw, y: superh * 0.5 + offset.y)
                to = CGPoint.init(x: -selfw * 0.5 + offset.x, y: superh * 0.5 + offset.y)
            }
            
        }else{
            
            from = self.center
            
            if slideDirection == .toTop {
                to = CGPoint.init(x: self.center.x + offset.x, y: -selfh)
            }else if slideDirection == .toBottom {
                to = CGPoint.init(x: self.center.x + offset.x, y: superh + selfh)
            }else if slideDirection == .toRight {
                to = CGPoint.init(x: superw + selfw, y: self.center.y + offset.y)
            }else if slideDirection == .toLeft {
                to = CGPoint.init(x: -selfw, y: self.center.y + offset.y)
            }
        }
        return (from,to)
    }
    
    
    
    // 根据折叠类型计算折叠的值
    func calculateFold(targetSize:CGSize,unfoldDirection:SPEightDirection,show:Bool = true) -> CGRect{
        
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
            }else if unfoldDirection == .toLeftRight {
                x = ss.width * 0.5
                y = 0
                w = 0
                h = ss.height
            }else if unfoldDirection == .toTopBottom {
                x = 0
                y = ss.height * 0.5
                w = ss.width
                h = 0
            }else if unfoldDirection == .center {
                x = ss.width * 0.5
                y = ss.height * 0.5
                w = 0
                h = 0
            }
            
        }
        return CGRect.init(x: x, y: y, width: w, height: h)
    }
    
    
    
    // 根据泡泡类型计算泡泡的anchorPoint值
    func calculateBubble(_ pinPoint:CGPoint,_ targetSize:CGSize,_ bubbleDirection:SPEightDirection) -> (CGPoint,CGRect){
        
        let ss = targetSize
        
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        
        var anchorPointx:CGFloat = 0.5
        var anchorPointy:CGFloat = 0.5
                
        if bubbleDirection == .toLeftBottom {
            anchorPointx = 1.0
            anchorPointy = 0.0
            x = pinPoint.x - ss.width
            y = pinPoint.y
        }else if bubbleDirection == .toLeft {
            anchorPointx = 1.0
            anchorPointy = 0.5
            x = pinPoint.x - ss.width
            y = pinPoint.y - ss.height * 0.5
        }else if bubbleDirection == .toLeftTop {
            anchorPointx = 1.0
            anchorPointy = 1.0
            x = pinPoint.x - ss.width
            y = pinPoint.y - ss.height
        }else if bubbleDirection == .toTop {
            anchorPointx = 0.5
            anchorPointy = 1.0
            x = pinPoint.x - ss.width * 0.5
            y = pinPoint.y - ss.height
        }else if bubbleDirection == .toRightTop {
            anchorPointx = 0.0
            anchorPointy = 1.0
            x = pinPoint.x
            y = pinPoint.y - ss.height
        }else if bubbleDirection == .toRight {
            anchorPointx = 0.0
            anchorPointy = 0.5
            x = pinPoint.x
            y = pinPoint.y - ss.height * 0.5
        }else if bubbleDirection == .toRightBottom {
            anchorPointx = 0.0
            anchorPointy = 0.0
            x = pinPoint.x
            y = pinPoint.y
        }else if bubbleDirection == .toBottom {
            anchorPointx = 0.5
            anchorPointy = 0.0
            x = pinPoint.x - ss.width * 0.5
            y = pinPoint.y
        }else if bubbleDirection == .center {
            anchorPointx = 0.5
            anchorPointy = 0.5
            x = pinPoint.x - ss.width * 0.5
            y = pinPoint.y - ss.height * 0.5
        }
        
        return (CGPoint.init(x: anchorPointx, y: anchorPointy),CGRect.init(x: x, y: y, width: ss.width, height: ss.height))
    }
    
    func setAnchorPoint(point:CGPoint,forView:UIView){
        let oldFrame = forView.frame
        forView.layer.anchorPoint = point
        forView.frame = oldFrame
    }
    
    func getFrame(_ size:CGSize,_ center:CGPoint) -> CGRect{
        let x = center.x - size.width * 0.5
        let y = center.y - size.height * 0.5
        return CGRect.init(origin: CGPoint.init(x: x, y: y), size: size)
    }
    
}
