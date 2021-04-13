//
//  SuperPopup.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation
//彻底理解position与anchorPoint
//https://www.cnblogs.com/benbenzhu/p/3615516.html

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
    public var description: String {
        switch self {
        case .x:
            return "x"
        case .y:
            return "y"
        case .z:
            return "z"
        default:
            return ""
        }
    }
}


// 旋转类型
public enum SPStepType : Int, Codable{
    case none = 0
    case show
    case hide
}

// 滑动方向
public enum SPFourDirection : Int, Codable{
    case none = 0
    case fromLeft
    case fromBottom
    case fromRight
    case fromTop
}

// 折叠展开方向
public enum SPEightDirection : Int, Codable{
    case none = 0
    case toLeftBottom
    case toLeft
    case toLeftTop
    case toTop
    case toRightTop
    case toRight
    case toRightBottom
    case toBottom
    case toLeftRight
    case toTopBottom
    case center
}

// 屏幕参数
public let sb: CGRect = UIScreen.main.bounds
public let sbs: CGSize = sb.size
public let sbw: CGFloat = sb.size.width
public let sbh: CGFloat = sb.size.height


public class SPManager:NSObject{
    
    var step : SPStepType = .none
    var target : UIView?
    var params = [Any]()
    
    public func spAlphaAnimation(_ closure: (_ make: SPAlphaParam ) -> Void) {
        let param = SPAlphaParam()
        param.type = .alpha
        if self.step == .none {
            return
        }else{
            param.from = self.target?.alpha ?? 0.0
            param.to = (self.step == .show) ? 1.0 : 0.0
        }
        self.params.append(param)
        closure(param)
    }
    
    public func spSlideAnimation(_ closure: (_ make: SPSlideParam ) -> Void) {
        let param = SPSlideParam()
        param.type = .slide
        param.slideDirection = .fromBottom
        self.params.append(param)
        closure(param)
    }
    
    public func spScaleAnimation(_ closure: (_ make: SPScaleParam ) -> Void) {
        let param = SPScaleParam()
        param.type = .scale
        param.spring = false
        if self.step == .none {
            return
        }else{
            param.from = (self.step == .show) ? 0.0 : 1.0
            param.to = (self.step == .show) ? 1.0 : 0.0
        }
        self.params.append(param)
        closure(param)
    }
    
    public func spFoldAnimation(_ closure: (_ make: SPFoldParam ) -> Void) {
        let param = SPFoldParam()
        param.type = .fold
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.unfoldDirection = .toBottom
        self.params.append(param)
        closure(param)
    }
    
    public func spBubbleAnimation(_ closure: (_ make: SPBubbleParam ) -> Void) -> SPManager {
        let param = SPBubbleParam()
        param.type = .bubble
        param.pinPoint = CGPoint.init(x: self.target?.frame.size.width ?? 0, y: 0)
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.bubbleDirection = .toLeftBottom
        self.params.append(param)
        closure(param)
        return self
    }
    
    public func finish() {
        self.target?.spMain(self)
    }
}

public protocol SPDataSource:NSObjectProtocol {
    
    func numberOfAnimation(_ spview:UIView,_ param:SPBaseParam) -> Int
    
    func animationForIndex(_ spview:UIView,_ param:SPBaseParam,index:Int) -> CAAnimation
    
}

extension UIView:SPDataSource{
    
    public func numberOfAnimation(_ spview:UIView,_ param:SPBaseParam) -> Int {
        if param.type == .alpha {
            return 1
        }else if param.type == .slide {
            return 1
        }else if param.type == .scale {
            return 1
        }else if param.type == .fold {
            return 1
        }else if param.type == .bubble {
            return 1
        }else if param.type == .mask {
            return 1
        }else if param.type == .other {
            return 0
        }
        return 0
    }
    
    public func animationForIndex(_ spview:UIView,_ param:SPBaseParam,index:Int) -> CAAnimation {
//        if type == .alpha {
//            return 1
//        }else if type == .slide {
//            return 1
//        }else if type == .scale {
//            return 1
//        }else if type == .fold {
//            return 1
//        }else if type == .bubble {
//            return 1
//        }else if type == .mask {
//            return 1
//        }else if type == .other {
//            return 0
//        }
//        return 0
    }
    
    
    
  
    

    var spshow: SPManager {
        self.spManager.step = .show
        self.spManager.target = self
        self.spDataSource = self
        return self.spManager
    }

    var sphide: SPManager {
        self.spManager.step = .hide
        self.spManager.target = self
        self.spDataSource = self
        return self.spManager
    }
    
    
    func spMain(_ manager:SPManager){
        
        let count:Int = self.spDataSource?.numberOfAnimation(self) ?? 0
        
        for index in 0..<count {
            let animation = self.spDataSource?.animationForIndex(self, index: index)
        }
        
        for (_,popupType) in manager.popupTypes.enumerated() {
            
            if popupType == .none {
                return
            }else if popupType == .alpha {
                if let param = manager.alphaParam {
                    
                    self.layer.add(self.packageAlphaAnimation(step: manager.step, from: param.from, to: param.to), forKey: "show_alpha")
                }
            }else if popupType == .slide {
                if let param = manager.slideParam {
                    self.layer.add(self.packageSlideAnimation(step: manager.step, slideDirection: param.slideDirection), forKey: "show_slide")
                }
            }else if popupType == .scale {
                if let param = manager.scaleParam {
                    self.layer.add(self.packageScaleAnimation(step: manager.step,spring: param.spring), forKey: "show_scale")
                }
            }else if popupType == .fold {
                if let param = manager.foldParam {
                    var shapeLayer = CAShapeLayer.init()
                    if let shape = self.layer.mask{
                        shapeLayer = shape as! CAShapeLayer
                    }else{
                        self.layer.mask = shapeLayer
                    }
                    shapeLayer.path = UIBezierPath.init(rect: self.calculateFold(targetSize: param.targetSize, unfoldDirection: param.unfoldDirection, show: manager.step == .show)).cgPath
                    shapeLayer.add(self.packageFoldAnimation(step: manager.step,unfoldDirection: param.unfoldDirection), forKey: "show_fold")
                }
            }else if popupType == .bubble {
                if let param = manager.bubbleParam {
                    self.layer.add(self.packageBubbleAnimation(step: manager.step, pinPoint: param.pinPoint, targetSize: param.targetSize, bubbleDirection: param.bubbleDirection), forKey: "show_bubble")
                }
            }
        }
    }
 

    func setAnchorPoint(point:CGPoint,forView:UIView){
        let oldFrame = forView.frame
        forView.layer.anchorPoint = point
        forView.frame = oldFrame
    }
    

    // 打包 bubble 封装动画类型
    func packageBubbleAnimation(step:SPStepType,pinPoint:CGPoint,targetSize:CGSize,bubbleDirection:SPEightDirection = .toBottom) -> CAAnimationGroup {
        
        let group:CAAnimationGroup = self.spAnimationGroup()

        let anchorPoint = self.calculateBubble(pinPoint: pinPoint, targetSize: targetSize, bubbleDirection: bubbleDirection).0
        let frame = self.calculateBubble(pinPoint: pinPoint, targetSize: targetSize, bubbleDirection: bubbleDirection).1
        
        self.frame = frame
        self.setAnchorPoint(point: anchorPoint, forView: self)
        
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
        
        return group
    }
    
    // 打包 fold 封装动画类型
    func packageFoldAnimation(step:SPStepType,unfoldDirection:SPEightDirection = .toBottom) -> CAAnimationGroup {
        
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
    func packageSlideAnimation(step:SPStepType,slideDirection:SPFourDirection) -> CAAnimationGroup {
        
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
    func packageAlphaAnimation(step:SPStepType,from:CGFloat,to:CGFloat) -> CAAnimationGroup {
        let group:CAAnimationGroup = self.spAnimationGroup()
        
        let ani = CAAnimation.spOpacityAnimation(values: [from,to], duration: 1)
        group.animations?.append(ani)
        return group
        
    }
    

}
