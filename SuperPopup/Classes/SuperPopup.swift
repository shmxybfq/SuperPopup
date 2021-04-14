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
    case path
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
// 泡泡类型
public enum SPBubbleType : Int, Codable{
    case scale = 0
    case mask
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
    
    public func spAlphaAnimation(_ closure: (_ make: SPAlphaParam ) -> Void) -> SPManager {
        let param = SPAlphaParam()
        param.type = .alpha
        param.from = self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        self.params.append(param)
        closure(param)
        return self
    }
    
    public func spSlideAnimation(_ closure: (_ make: SPSlideParam ) -> Void) -> SPManager {
        let param = SPSlideParam()
        param.type = .slide
        param.slideDirection = .fromBottom
        self.params.append(param)
        closure(param)
        return self
    }
    
    public func spScaleAnimation(_ closure: (_ make: SPScaleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPScaleParam()
        param.type = .scale
        param.spring = false
        param.from = (self.step == .show) ? 0.0 : 1.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        self.params.append(param)
        closure(param)
        return self
    }
    
    public func spFoldAnimation(_ closure: (_ make: SPFoldParam ) -> Void) -> SPManager {
        let param = SPFoldParam()
        param.type = .fold
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.unfoldDirection = .toBottom
        self.params.append(param)
        closure(param)
        return self
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
    
    func animationTypes(_ spview:UIView,_ step:SPStepType,_ param:Any) -> [SPBaseAnimationType]
    
    func animationForIndex(_ spview:UIView,_ step:SPStepType,_ param:Any,type:SPBaseAnimationType,index:Int) -> CAAnimation?
    
}

extension UIView:SPDataSource{
    
    
    public var spshow: SPManager {
        self.spManager.step = .show
        self.spManager.target = self
        self.spDataSource = self
        return self.spManager
    }

    public var sphide: SPManager {
        self.spManager.step = .hide
        self.spManager.target = self
        self.spDataSource = self
        return self.spManager
    }
    
    
    
    func spMain(_ manager:SPManager){
        
        for param in manager.params {
            if let prm = param as? SPBaseParam {
                let types = self.spDataSource?.animationTypes(self, manager.step, prm) ?? []
                for (index,type) in types.enumerated() {
                    let animation = self.spDataSource?.animationForIndex(self, manager.step, prm, type: type, index: index)
                    if animation != nil {
                        prm.typeAnimations[type] = animation
                    }
                }
            }
        }
        
        var anis = [CAAnimation]()
        for (_,param) in manager.params.enumerated() {
            if let prm = param as? SPBaseParam {
                for (_,animation) in prm.typeAnimations {
                    anis.append(animation)
                }
            }
        }
        let group = self.spAnimationGroup()
        group.animations = anis
        
        self.layer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
        
    }
        
    
    public func animationTypes(_ spview: UIView, _ step: SPStepType, _ param: Any) -> [SPBaseAnimationType] {
        if let baseParam = param as? SPBaseParam{
            if baseParam.type == .none {
                return [.none]
            }else if baseParam.type == .alpha {
                return [.opacity]
            }else if baseParam.type == .slide {
                return [.position]
            }else if baseParam.type == .scale {
                return [.scale]
            }else if baseParam.type == .fold {
                return [.path]
            }else if baseParam.type == .bubble,let bubbleParam = baseParam as? SPBubbleParam {
                if bubbleParam.bubbleType == .mask {
                    return [.path]
                }else{
                    return [.scale]
                }
            }else if baseParam.type == .mask {
                return [.path]
            }else if baseParam.type == .other {
                return [.none]
            }
        }
        return []
    }
  
    public func animationForIndex(_ spview: UIView, _ step: SPStepType, _ param: Any, type: SPBaseAnimationType, index: Int) -> CAAnimation? {
        var animation:CAAnimation? = nil
        if type == .none {
            let from:CGFloat = self.alpha
            var to:CGFloat = self.alpha
            if step == .show {
                to = 1.0
            }else if step == .show {
                to = 0.0
            }
            animation = CAAnimation.spOpacityAnimation(values: [from,to], duration: 1)
            
        }else if type == .opacity,let alphaParam = param as? SPAlphaParam {
            
            animation = CAAnimation.spOpacityAnimation(values: [alphaParam.from,alphaParam.to], duration: 1)
            
        }else if type == .position,let slideParam = param as? SPSlideParam {
            
            var from:CGPoint = CGPoint.zero
            var to:CGPoint = CGPoint.zero
            if step == .show {
                from = self.calculatePosition(slideDirection: slideParam.slideDirection, show: true)
                to = self.calculatePosition(slideDirection: slideParam.slideDirection, show: false)
            }else if step == .hide{
                from = self.calculatePosition(slideDirection: slideParam.slideDirection, show: false)
                to = self.calculatePosition(slideDirection: slideParam.slideDirection, show: true)
            }
            animation = CAAnimation.spPositionAnimation(values: [from,to], duration: 1)
            
        }else if type == .scale,let scaleParam = param as? SPScaleParam {
            
            self.setAnchorPoint(point: CGPoint.init(x: 0.5, y: 0.5), forView: self)
            
            if scaleParam.spring {
                var values:[Double] = []
                values.append(0.0)
                values.append(1.2)
                values.append(0.9)
                values.append(1.0)
                if step == .hide {
                    values.reverse()
                }
                animation = CAAnimation.spScaleAnimation(values: values, duration: 1)
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
                animation = CAAnimation.spScaleAnimation(values: [from,to], duration: 1)
            }
            
        }else if type == .path,let foldParam = param as? SPFoldParam {
            
            var from:CGRect = CGRect.zero
            var to:CGRect = CGRect.zero

            if step == .show {
                from = self.calculateFold(targetSize: self.frame.size, unfoldDirection: foldParam.unfoldDirection, show: false)
                to = self.calculateFold(targetSize: self.frame.size, unfoldDirection: foldParam.unfoldDirection, show: true)
            }else if step == .hide{
                from = self.calculateFold(targetSize: self.frame.size, unfoldDirection: foldParam.unfoldDirection, show: true)
                to = self.calculateFold(targetSize: self.frame.size, unfoldDirection: foldParam.unfoldDirection, show: false)
            }
            let fromPath = UIBezierPath.init(rect: from)
            let toPath = UIBezierPath.init(rect: to)
            animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: 1)
            
        }else if type == .path,let bubbleParam = param as? SPBubbleParam,bubbleParam.bubbleType == .scale {
            
            let anchorPoint = self.calculateBubble(pinPoint: bubbleParam.pinPoint, targetSize: bubbleParam.targetSize, bubbleDirection: bubbleParam.bubbleDirection).0
            let frame = self.calculateBubble(pinPoint: bubbleParam.pinPoint, targetSize: bubbleParam.targetSize, bubbleDirection: bubbleParam.bubbleDirection).1
            
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
            animation = CAAnimation.spScaleAnimation(values: [from,to], duration: 1)
            
        }else if type == .path,let bubbleParam = param as? SPBubbleParam,bubbleParam.bubbleType == .mask {
            
            var from:CGRect = CGRect.zero
            var to:CGRect = CGRect.zero

            let frame = self.calculateBubble(pinPoint: bubbleParam.pinPoint, targetSize: bubbleParam.targetSize, bubbleDirection: bubbleParam.bubbleDirection).1
            
            self.frame = frame
            
            if step == .show {
                from = self.calculateFold(targetSize: bubbleParam.targetSize, unfoldDirection: bubbleParam.bubbleDirection, show: false)
                to = self.calculateFold(targetSize: bubbleParam.targetSize, unfoldDirection: bubbleParam.bubbleDirection, show: true)
            }else if step == .hide{
                from = self.calculateFold(targetSize: bubbleParam.targetSize, unfoldDirection: bubbleParam.bubbleDirection, show: true)
                to = self.calculateFold(targetSize: bubbleParam.targetSize, unfoldDirection: bubbleParam.bubbleDirection, show: false)
            }
            let fromPath = UIBezierPath.init(rect: from)
            let toPath = UIBezierPath.init(rect: to)
            animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: 1)
        }
        return animation
        
    }
    
    



}
