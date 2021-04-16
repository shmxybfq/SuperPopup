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
    public var target : UIView?
    public var inView : UIView? = UIApplication.shared.keyWindow
    var param : SPParam = SPParam.init()
    
    var packageParams = [Any]()
    var backgrounds : [UIView] = [UIView]()
    
    public func spNoAnimation(_ closure: (_ make: SPAlphaParam ) -> Void = {_ in }) {
        let param = SPAlphaParam()
        param.type = .alpha
        param.from = self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.finish(SPParam.init(0.0))
    }
    
    public func spAlphaAnimation(_ closure: (_ make: SPAlphaParam ) -> Void = {_ in }) -> SPManager {
        let param = SPAlphaParam()
        param.type = .alpha
        param.from = self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        return self
    }
    
    public func spSlideAnimation(_ closure: (_ make: SPSlideParam ) -> Void = {_ in }) -> SPManager {
        let param = SPSlideParam()
        param.type = .slide
        param.slideDirection = .fromBottom
        closure(param)
        self.packageParams.append(param)
        return self
    }
    
    public func spScaleAnimation(_ closure: (_ make: SPScaleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPScaleParam()
        param.type = .scale
        param.spring = false
        param.from = (self.step == .show) ? 0.0 : 1.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        return self
    }
    
    public func spFoldAnimation(_ closure: (_ make: SPFoldParam ) -> Void = {_ in }) -> SPManager {
        let param = SPFoldParam()
        param.type = .fold
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.unfoldDirection = .toBottom
        closure(param)
        self.packageParams.append(param)
        return self
    }
    
    public func spBubbleAnimation(_ closure: (_ make: SPBubbleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPBubbleParam()
        param.type = .bubble
        param.pinPoint = self.target?.center ?? CGPoint.zero
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.bubbleDirection = .toLeftBottom
        closure(param)
        self.packageParams.append(param)
        return self
    }
    
    public func finish(_ param:SPParam = SPParam.init()) {
        self.param = param
        self.target?.spMain(self)
    }
}

public protocol SPDataSource:NSObjectProtocol {
    
    func animationTypes(_ spview:UIView,_ step:SPStepType,_ param:Any) -> [SPBaseAnimationType]
    
    func animationForIndex(_ spview:UIView,_ step:SPStepType,_ param:Any,type:SPBaseAnimationType,index:Int) -> CAAnimation?
    
}

public protocol SPBackgroundProtocol:NSObjectProtocol {
    
    func backgroundCount(_ spview:UIView) -> Int
    
    func backgroundViewForIndex(_ spview:UIView,index:Int) -> UIView
    
    func backgroundTouch(_ spview:UIView,_ background:UIView) -> Bool
}

extension UIView:SPDataSource,SPBackgroundProtocol,CAAnimationDelegate{


    public func spshow(_ inView: UIView?) -> SPManager {
        self.spManager.inView = inView
        self.spManager.step = .show
        self.spManager.target = self
        self.spDataSource = self
        self.spBackgroundDelegate = self
        self.spManager.packageParams.removeAll()
        self.ending = SPEnding.init(self.alpha, self.frame,self.center,self.frame.size)
        return self.spManager
    }
    
    public var sphide: SPManager {
        self.spManager.step = .hide
        self.spManager.target = self
        self.spDataSource = self
        self.spBackgroundDelegate = self
        self.spManager.packageParams.removeAll()
        self.ending = SPEnding.init(self.alpha, self.frame,self.center,self.frame.size)
        return self.spManager
    }
    
    
    func spMain(_ manager:SPManager){
        
        for param in manager.packageParams {
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
        
        var animations = [CAAnimation]()
        var maskAnimations = [CAAnimation]()
        for (_,param) in manager.packageParams.enumerated() {
            if let prm = param as? SPBaseParam {
                for (_,animation) in prm.typeAnimations {
                    if let property = animation as? CAPropertyAnimation{
                        if property.keyPath == "path" {
                            maskAnimations.append(property)
                        }else{
                            animations.append(property)
                            if property.keyPath == "opacity" {
                                if let basic = property as? CABasicAnimation,let to = basic.toValue as? CGFloat {
                                    self.ending?.alpha = to
                                }else if let key = property as? CAKeyframeAnimation,(key.values?.count ?? 0) > 0 {
                                    let last = key.values?.last
                                    if let to = last as? CGFloat {
                                        self.ending?.alpha = to
                                    }
                                }
                            }else if property.keyPath == "position" {
                                if let basic = property as? CABasicAnimation,let to = basic.toValue as? CGPoint {
                                    self.ending?.position = to
                                }else if let key = property as? CAKeyframeAnimation,(key.values?.count ?? 0) > 0 {
                                    let last = key.values?.last
                                    if let to = last as? CGPoint {
                                        self.ending?.position = to
                                    }
                                }
                            }else if property.keyPath == "bounds.size" {
                                if let basic = property as? CABasicAnimation,let to = basic.toValue as? CGSize {
                                    self.ending?.size = to
                                }else if let key = property as? CAKeyframeAnimation,(key.values?.count ?? 0) > 0 {
                                    let last = key.values?.last
                                    if let to = last as? CGSize {
                                        self.ending?.size = to
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if self.spManager.step == .show && self.spManager.inView != nil{
            // 背景
            let backgroundCount = self.spBackgroundDelegate?.backgroundCount(self) ?? 0
            if backgroundCount > 0 {
                for index in 0..<backgroundCount {
                    let background = self.spBackgroundDelegate?.backgroundViewForIndex(self, index: index)
                    if let bk = background {
                        self.spManager.backgrounds.append(bk)
                        self.spManager.inView?.addSubview(bk)
                    }
                }
            }else{
                if self.spManager.param.backgroundView != nil{
                    self.spManager.param.backgroundView?.alpha = 0.0
                    self.spManager.param.backgroundView?.frame = self.spManager.inView?.bounds ?? sb
                    if let bk = self.spManager.param.backgroundView as? UIButton {
                        bk.addTarget(self, action: #selector(defaultBackgroundClick(ins:)), for: .touchUpInside)
                    }
                    self.spManager.inView?.addSubview(self.spManager.param.backgroundView!)
                    UIView.animate(withDuration: self.spManager.param.duration, delay: self.spManager.param.delay, options: UIViewAnimationOptions.curveEaseOut) {
                        self.spManager.param.backgroundView?.alpha = 1.0
                    } completion: { (finish) in}
                }
            }
            
            // 弹窗视图
            if self.superview != nil{
                self.removeFromSuperview()
            }
            self.spManager.inView?.addSubview(self)
        }
        
        if animations.count > 0 {
            let group = self.spAnimationGroup()
            group.animations = animations
            group.duration = self.spManager.param.duration
            group.delegate = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.spManager.param.delay) {
                self.layer.removeAllAnimations()
                self.layer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
            }
        }
        
        if maskAnimations.count > 0 {
            let group = self.spAnimationGroup()
            group.animations = maskAnimations
            group.duration = self.spManager.param.duration
            group.delegate = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.spManager.param.delay) {
                self.shapeLayer.removeAllAnimations()
                self.shapeLayer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
            }
        }
    }
    
    // 默认背景点击
    @objc func defaultBackgroundClick(ins:UIButton){
        
        if self.spBackgroundDelegate?.backgroundTouch(self, self.spManager.param.backgroundView ?? UIView.init()) == true {
            self.spManager.param.delay = 0.0
            self.sphide.spAlphaAnimation { (param) in
                param.to = 0.0
            }.finish(self.spManager.param)
            
            UIView.animate(withDuration: self.spManager.param.duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut) {
                self.spManager.param.backgroundView?.alpha = 0.0
            } completion: { (finish) in}
        }
    }
    
    
    public func animationDidStart(_ anim: CAAnimation){
        
    }

    
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        print("======%p",anim)
//        self.alpha = self.ending?.alpha ?? self.alpha
//        self.frame = CGRect.init(origin: CGPoint.zero, size: self.ending?.size ?? self.frame.size)
//        self.center = self.ending?.position ?? self.center
    }
    
    
    @objc open func backgroundCount(_ spview: UIView) -> Int {
        return 0
    }
    
    @objc open func backgroundViewForIndex(_ spview: UIView, index: Int) -> UIView {
        return UIButton.init(type: .custom)
    }
    
    @objc open func backgroundTouch(_ spview: UIView, _ background: UIView) -> Bool {
        return true
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
            }else if step == .hide {
                to = 0.0
            }
            animation = CAAnimation.spOpacityAnimation(values: [from,to], duration: 0.0)
            
        }else if type == .opacity,let alphaParam = param as? SPAlphaParam {
            
            animation = CAAnimation.spOpacityAnimation(values: [alphaParam.from,alphaParam.to], duration: alphaParam.duration)
            
        }else if type == .position,let slideParam = param as? SPSlideParam {
            
            if slideParam.slideDirection == .none {
                return nil
            }
            var from:CGPoint = CGPoint.zero
            var to:CGPoint = CGPoint.zero
            let offset = self.spManager.param.offset
            if step == .show {
                from = self.calculatePosition(slideDirection: slideParam.slideDirection, show: true)
                to = self.calculatePosition(slideDirection: slideParam.slideDirection, show: false)
            }else if step == .hide{
                from = self.calculatePosition(slideDirection: slideParam.slideDirection, show: false)
                to = self.calculatePosition(slideDirection: slideParam.slideDirection, show: true)
            }
            
            from = CGPoint.init(x: from.x + offset.x, y: from.y + offset.y)
            to = CGPoint.init(x: to.x + offset.x, y: to.y + offset.y)
            
            animation = CAAnimation.spPositionAnimation(values: [from,to], duration: slideParam.duration)
            
        }else if type == .scale,let scaleParam = param as? SPScaleParam {
            
            self.setAnchorPoint(point: CGPoint.init(x: 0.5, y: 0.5), forView: self)
            
            if scaleParam.spring {
                var values:[CGFloat] = []
                values.append(0.0)
                values.append(1.2)
                values.append(0.9)
                values.append(1.0)
                if step == .hide {
                    values.reverse()
                }
                animation = CAAnimation.spScaleAnimation(values: values, duration: scaleParam.duration)
            }else{
                animation = CAAnimation.spScaleAnimation(values: [scaleParam.from,scaleParam.to], duration: scaleParam.duration)
            }
            
        }else if type == .path,let foldParam = param as? SPFoldParam {
            
            if foldParam.unfoldDirection == .none {
                return nil
            }
            var from:CGRect = CGRect.zero
            var to:CGRect = CGRect.zero

            if step == .show {
                from = self.calculateFold(targetSize: foldParam.targetSize, unfoldDirection: foldParam.unfoldDirection, show: false)
                to = self.calculateFold(targetSize: foldParam.targetSize, unfoldDirection: foldParam.unfoldDirection, show: true)
            }else if step == .hide{
                from = self.calculateFold(targetSize: foldParam.targetSize, unfoldDirection: foldParam.unfoldDirection, show: true)
                to = self.calculateFold(targetSize: foldParam.targetSize, unfoldDirection: foldParam.unfoldDirection, show: false)
            }
            let fromPath = UIBezierPath.init(rect: from)
            let toPath = UIBezierPath.init(rect: to)
            animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: foldParam.duration)
            
        }else if type == .scale,let bubbleParam = param as? SPBubbleParam,bubbleParam.bubbleType == .scale {
            
            if bubbleParam.bubbleDirection == .none {
                return nil
            }
            
            let anchorPoint = self.calculateBubble(pinPoint: bubbleParam.pinPoint, targetSize: bubbleParam.targetSize, bubbleDirection: bubbleParam.bubbleDirection).0
            let frame = self.calculateBubble(pinPoint: bubbleParam.pinPoint, targetSize: bubbleParam.targetSize, bubbleDirection: bubbleParam.bubbleDirection).1
            
            self.frame = frame
            
            self.setAnchorPoint(point: anchorPoint, forView: self)
            
            var from:CGFloat = 1.0
            var to:CGFloat = 1.0
            if step == .show {
                from = 0.0
                to = 1.0
            }else if step == .hide{
                from = 1.0
                to = 0.0
            }
            animation = CAAnimation.spScaleAnimation(values: [from,to], duration: bubbleParam.duration)
            
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
            animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: bubbleParam.duration)
            
        }else if type == .path,let maskParam = param as? SPMaskParam {
            
            let fromPath = maskParam.from
            let toPath = maskParam.to
            
            animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: maskParam.duration)
            
        }
        
        animation?.duration = self.spManager.param.duration
        animation?.delegate = self
        animation?.duration = self.spManager.param.duration
    
        return animation
    }
}
