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
    case rotation
    case custom
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
    case custom
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

// 方向
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


/// 数据源代理
public protocol SPDataSource:NSObjectProtocol {
    
    func animationTypes(_ spview:UIView,_ step:SPStepType,_ param:Any) -> [SPBaseAnimationType]
    
    func animationForIndex(_ spview:UIView,_ step:SPStepType,_ param:Any,type:SPBaseAnimationType,index:Int) -> CAAnimation?
    
    func customAnimationForIndex(_ spview:UIView,_ step:SPStepType,_ param:Any,type:SPBaseAnimationType,index:Int) -> CAAnimation?
}


/// 事件代理
public protocol SPDelegate:NSObjectProtocol {
    
    func spInit(_ spview:UIView,_ manager:SPManager)
    
    func spWillPackageAnimation(_ spview:UIView,_ manager:SPManager)
    
    func spDidPackageAnimation(_ spview:UIView,_ manager:SPManager,_ param:SPBaseParam)

    func spWillBegin(_ spview:UIView,_ manager:SPManager)

    func spWillGetAnimations(_ spview:UIView,_ manager:SPManager)
    
    func spDidGetAnimations(_ spview:UIView,_ manager:SPManager)
    
    func spWillCommit(_ spview:UIView,_ manager:SPManager,_ animations:[CAAnimation],_ maskAnimations:[CAAnimation])
    
    func spDidCommited(_ spview:UIView,_ manager:SPManager)
    
    func spAnimationDidRun(_ spview:UIView,_ manager:SPManager,_ mark:Any)
    
    func spWillDoBackground(_ spview:UIView,_ manager:SPManager)
    
    func spBackgroundDidAddedToView(_ spview:UIView,_ manager:SPManager,_ backgroundView:UIView,_ index:Int)
    
    func spBackgroundDidAddedAll(_ spview:UIView,_ manager:SPManager)
    
    func spDefaultBackgroundDidAddedToViewAndCommited(_ spview:UIView,_ manager:SPManager)
    
    func spDefaultBackgroundAnimationDidRun(_ spview:UIView,_ manager:SPManager)
    
    func animationDidStart(_ spview:UIView,_ manager:SPManager,_ anim: CAAnimation?)
    
    func spAnimationDidStop(_ spview:UIView,_ manager:SPManager,_ anim: CAAnimation?, finished flag: Bool,_ error:NSError?)
}


/// 背景代理
public protocol SPBackgroundProtocol:NSObjectProtocol {
    
    func backgroundCount(_ spview:UIView) -> Int
    
    func backgroundViewForIndex(_ spview:UIView,index:Int) -> UIView
    
    func backgroundTouch(_ spview:UIView,_ background:UIView) -> Bool
}


public class SPManager:NSObject{
    
    var step : SPStepType = .none
    public var target : UIView?
    public var inView : UIView? = UIApplication.shared.keyWindow
    var param : SPParam = SPParam.init()
    
    var packageParams = [Any]()
    var backgrounds : [UIView] = [UIView]()
    
    var animating : Bool = false

    public func spNoAnimation(_ closure: (_ make: SPAlphaParam ) -> Void = {_ in }) {
        let param = SPAlphaParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .alpha
        param.from = self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        self.finish(SPParam.init(0.0))
    }
    
    public func spAlphaAnimation(_ closure: (_ make: SPAlphaParam ) -> Void = {_ in }) -> SPManager {
        let param = SPAlphaParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .alpha
        param.from = self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    public func spSlideAnimation(_ closure: (_ make: SPSlideParam ) -> Void = {_ in }) -> SPManager {
        let param = SPSlideParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .slide
        param.slideDirection = .toTop
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    public func spScaleAnimation(_ closure: (_ make: SPScaleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPScaleParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .scale
        param.spring = false
        param.from = (self.step == .show) ? 0.0 : 1.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    public func spFoldAnimation(_ closure: (_ make: SPFoldParam ) -> Void = {_ in }) -> SPManager {
        let param = SPFoldParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .fold
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.unfoldDirection = .toBottom
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    public func spBubbleAnimation(_ closure: (_ make: SPBubbleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPBubbleParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .bubble
        param.pinPoint = self.target?.center ?? CGPoint.zero
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.bubbleDirection = .toLeftBottom
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    public func spRotationAnimation(_ closure: (_ make: SPRotationParam ) -> Void = {_ in }) -> SPManager {
        let param = SPRotationParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.type = .rotation
        param.from = (self.step == .show) ? 0.0 : Double.pi * 2.0
        param.to = (self.step == .show) ? Double.pi * 2.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    public func finish(_ param:SPParam = SPParam.init()) {
        self.param = param
        self.target?.spMain(self)
    }
}


extension UIView:SPDataSource,SPDelegate,SPBackgroundProtocol,CAAnimationDelegate{
  
    
    public func spshow(_ inView: UIView? = UIApplication.shared.keyWindow) -> SPManager {
        self.spManager.inView = inView
        self.spManager.step = .show
        self.spManager.target = self
        self.spDataSource = self
        self.spDelegate = self
        self.spBackgroundDelegate = self
        self.spManager.packageParams.removeAll()
        self.ending = SPEnding()
        self.spDelegate?.spInit(self, self.spManager)
        return self.spManager
    }
    
    public var sphide: SPManager {
        self.spManager.step = .hide
        self.spManager.target = self
        self.spDataSource = self
        self.spDelegate = self
        self.spBackgroundDelegate = self
        self.spManager.packageParams.removeAll()
        self.ending = SPEnding()
        self.spDelegate?.spInit(self, self.spManager)
        
        return self.spManager
    }
    
    
    func spMain(_ manager:SPManager){
        
        // 将要开始执行动画操作
        self.spDelegate?.spWillBegin(self, self.spManager)
        
        //如果无inView
        if self.spManager.inView == nil {
            self.spDelegate?.spAnimationDidStop(self, self.spManager, nil, finished: false, NSError.init(domain: "inView is null", code: 100, userInfo: nil))
            return
        }
        
        //如果正在执行动画则不执行事务
        if self.spManager.animating {
            self.spDelegate?.spAnimationDidStop(self, self.spManager, nil, finished: false, NSError.init(domain: "animating", code: 101, userInfo: nil))
            return
        }
        
        
        self.spDelegate?.spWillGetAnimations(self, self.spManager)
        
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
        
        self.spDelegate?.spDidGetAnimations(self, self.spManager)
        
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
                        }
                    }
                }
            }
        }
        
        self.spDelegate?.spWillCommit(self, self.spManager, animations, maskAnimations)
        
        // 处理图层
        if animations.count > 0 || maskAnimations.count > 0 {
            if self.superview != nil{
                self.removeFromSuperview()
            }
            self.spManager.inView?.addSubview(self)
        }
        
        // 提交动画
        if animations.count > 0 {
            let group = self.spAnimationGroup()
            group.animations = animations
            group.duration = self.spManager.param.duration
            group.delegate = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.spManager.param.delay) {
                self.spManager.animating = true
                self.layer.removeAllAnimations()
                self.layer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
                self.spDelegate?.spAnimationDidRun(self, self.spManager, "normal")
            }
        }
        
        if maskAnimations.count > 0 {
            let group = self.spAnimationGroup()
            group.animations = maskAnimations
            group.duration = self.spManager.param.duration
            group.delegate = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.spManager.param.delay) {
                self.spManager.animating = true
                self.shapeLayer.removeAllAnimations()
                self.shapeLayer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
                self.spDelegate?.spAnimationDidRun(self, self.spManager, "mask")
            }
        }
        
        self.spDelegate?.spDidCommited(self, self.spManager)
        
        
        if self.spManager.step == .show{
            // 背景
            self.spDelegate?.spWillDoBackground(self, self.spManager)
            
            let backgroundCount = self.spBackgroundDelegate?.backgroundCount(self) ?? 0
            if backgroundCount > 0 {
                for index in 0..<backgroundCount {
                    let background = self.spBackgroundDelegate?.backgroundViewForIndex(self, index: index)
                    if let bk = background {
                        self.spManager.backgrounds.append(bk)
                        self.spManager.inView?.addSubview(bk)
                        self.spDelegate?.spBackgroundDidAddedToView(self, self.spManager, bk, index)
                    }
                }
                self.spDelegate?.spBackgroundDidAddedAll(self, self.spManager)
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
                        self.spDelegate?.spDefaultBackgroundAnimationDidRun(self, self.spManager)
                    } completion: { (finish) in}
                    self.spDelegate?.spDefaultBackgroundDidAddedToViewAndCommited(self, self.spManager)
                }
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
            } completion: { (finish) in
                self.spManager.param.backgroundView?.removeFromSuperview()
            }
        }
    }
    
    
    public func animationDidStart(_ anim: CAAnimation){
        self.spDelegate?.animationDidStart(self, self.spManager, anim)
    }
    
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        
        self.spDelegate?.spAnimationDidStop(self, self.spManager, anim, finished: flag, nil)
        
        if self.ending?.alpha != -1 {
            self.alpha = self.ending?.alpha ?? self.alpha
        }
        if self.ending?.frame != CGRect.zero {
            self.frame = self.ending?.frame ?? self.frame
        }
        if self.spManager.step == .show {
            self.spManager.animating = false
        }else{
            self.spManager = SPManager.init()
            if self.spManager.param.backgroundView?.superview != nil {
                self.spManager.param.backgroundView?.removeFromSuperview()
                self.removeFromSuperview()
            }
            self.alpha = 1.0
            self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            self.layer.contentsScale = 1.0
        }
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
                return []
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
            }else if baseParam.type == .rotation {
                return [.rotation]
            }else if baseParam.type == .custom {
                return [.custom]
            }
        }
        return []
    }
  
    public func animationForIndex(_ spview: UIView, _ step: SPStepType, _ param: Any, type: SPBaseAnimationType, index: Int) -> CAAnimation? {
        
        var animation:CAAnimation? = nil
        
        if type == .none {
            
            return nil
            
        }else if type == .opacity,let alphaParam = param as? SPAlphaParam {
            
            self.ending?.alpha = alphaParam.to
            animation = CAAnimation.spOpacityAnimation(values: [alphaParam.from,alphaParam.to], duration: alphaParam.duration)
            
        }else if type == .position,let slideParam = param as? SPSlideParam {
            
            if slideParam.slideDirection == .none {
                return nil
            }
            
            var from = self.calculatePosition(slideParam.slideDirection, step, self.spManager.param.offset).0
            if slideParam.from != CGPoint.zero {
                from = slideParam.from
            }
            
            var to = self.calculatePosition(slideParam.slideDirection, step, self.spManager.param.offset).1
            if slideParam.to != CGPoint.zero {
                to = slideParam.to
            }
            
            self.ending?.frame = self.getFrame(self.frame.size, to)
            
            animation = CAAnimation.spPositionAnimation(values: [from,to], duration: slideParam.duration)
            
        }else if type == .scale,let scaleParam = param as? SPScaleParam {
            
            let anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            self.setAnchorPoint(point: anchorPoint, forView: self)
            self.ending?.anchorPoint = anchorPoint
            
            if scaleParam.spring {
                var values:[CGFloat] = []
                values.append(0.0)
                values.append(1.2)
                values.append(0.9)
                values.append(1.0)
                self.ending?.scale = 1.0
                if step == .hide {
                    values.reverse()
                    self.ending?.scale = 0.0
                }
                animation = CAAnimation.spScaleAnimation(values: values, duration: scaleParam.duration)
            }else{
                animation = CAAnimation.spScaleAnimation(values: [scaleParam.from,scaleParam.to], duration: scaleParam.duration)
                self.ending?.scale = scaleParam.to
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
            
            let from:CGFloat = (step == .show) ? 0.0 : 1.0
            let to:CGFloat = (step == .show) ? 1.0 : 0.0
            
            let anchorPoint = self.calculateBubble(bubbleParam.pinPoint, bubbleParam.targetSize, bubbleParam.bubbleDirection).0
            self.frame = self.calculateBubble(bubbleParam.pinPoint, bubbleParam.targetSize, bubbleParam.bubbleDirection).1
            
            self.ending?.frame = self.frame
            self.ending?.anchorPoint = anchorPoint
            self.ending?.scale = to
            
            self.setAnchorPoint(point: anchorPoint, forView: self)
            
            animation = CAAnimation.spScaleAnimation(values: [from,to], duration: bubbleParam.duration)
            
        }else if type == .path,let bubbleParam = param as? SPBubbleParam,bubbleParam.bubbleType == .mask {
            
            var from:CGRect = CGRect.zero
            var to:CGRect = CGRect.zero

            self.frame = self.calculateBubble(bubbleParam.pinPoint, bubbleParam.targetSize, bubbleParam.bubbleDirection).1
            self.ending?.frame = self.frame

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
            
        }else if type == .rotation,let rotationParam = param as? SPRotationParam {

            let from:Double = rotationParam.from
            let to:Double = rotationParam.to
            
            animation = CAAnimation.spRotationAnimation(rotationType: rotationParam.rotationType, values: [from,to], duration: rotationParam.duration)
            
        }else if type == .custom {
            
            animation = self.customAnimationForIndex(spview, step, param, type: type, index: index)
            assert(animation != nil, "please implement customAnimationForIndex method,and return a valid CAAnimation instance")
        }
        
        animation?.duration = self.spManager.param.duration
        animation?.delegate = self
        animation?.duration = self.spManager.param.duration
    
        return animation
    }
    
    public func customAnimationForIndex(_ spview: UIView, _ step: SPStepType, _ param: Any, type: SPBaseAnimationType, index: Int) -> CAAnimation? {
        return nil
    }
    
    
    
    public func spInit(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spWillPackageAnimation(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spDidPackageAnimation(_ spview: UIView, _ manager: SPManager, _ param: SPBaseParam) {
        
    }
    
    public func spWillBegin(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spWillGetAnimations(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spDidGetAnimations(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spWillCommit(_ spview: UIView, _ manager: SPManager, _ animations: [CAAnimation], _ maskAnimations: [CAAnimation]) {
        
    }
    
    public func spDidCommited(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spAnimationDidRun(_ spview: UIView, _ manager: SPManager, _ mark: Any) {
        
    }
    
    public func spWillDoBackground(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spBackgroundDidAddedToView(_ spview: UIView, _ manager: SPManager, _ backgroundView: UIView, _ index: Int) {
        
    }
    
    public func spBackgroundDidAddedAll(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spDefaultBackgroundDidAddedToViewAndCommited(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    public func spDefaultBackgroundAnimationDidRun(_ spview: UIView, _ manager: SPManager) {
        
    }
   
    public func animationDidStart(_ spview: UIView, _ manager: SPManager, _ anim: CAAnimation?) {
        
    }
    
    public func spAnimationDidStop(_ spview: UIView, _ manager: SPManager, _ anim: CAAnimation?, finished flag: Bool, _ error: NSError?) {
        
    }
    

}
