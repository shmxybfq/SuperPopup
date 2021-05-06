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

/// 打包动画类型
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


/// 基础动画类型
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


/// 旋转轴
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


/// 弹窗阶段
public enum SPStepType : Int, Codable{
    case none = 0
    case show
    case hide
}

/// 方向
public enum SPDirection : Int, Codable{
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


/// 泡泡类型
public enum SPBubbleType : Int, Codable{
    case scale = 0
    case mask
}


/// 屏幕尺寸
public let sb: CGRect = UIScreen.main.bounds
public let sbs: CGSize = sb.size
public let sbw: CGFloat = sb.size.width
public let sbh: CGFloat = sb.size.height


/// 数据源代理
public protocol SPDataSource:NSObjectProtocol {
    
    
    /// 根据相关参数返回基础动画类型
    /// - Parameters:
    ///   - spview: 执行动画的view
    ///   - step: 动画阶段
    ///   - param: 动画参数 SPBaseParam的子类:[SPAlphaParam,SPSlideParam,SPScaleParam,SPFoldParam,SPBubbleParam,SPMaskParam,SPRotationParam,SPCustomParam]
    func animationTypes(_ spview:UIView,_ step:SPStepType,_ param:Any) -> [SPBaseAnimationType]
    
    
    /// 返回动画对象
    /// - Parameters:
    ///   - spview: 执行动画的view
    ///   - step: 动画阶段
    ///   - param: 动画参数
    ///   - type: 基础动画类型
    ///   - index: 下标
    func animationForIndex(_ spview:UIView,_ step:SPStepType,_ param:Any,type:SPBaseAnimationType,index:Int) -> CAAnimation?
    
    
    /// 返回自定义动画对象数组
    /// - Parameters:
    ///   - spview: 执行动画的view
    ///   - step: 动画阶段
    ///   - param: 动画参数
    ///   - type: 基础动画类型
    ///   - index: 下标
    func customAnimationForIndex(_ spview:UIView,_ step:SPStepType,_ param:Any,type:SPBaseAnimationType,index:Int) -> CAAnimation?
}


/// 事件代理
public protocol SPDelegate:NSObjectProtocol {
    
    
    /// 动画管理类初始化完成
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spInited(_ spview:UIView,_ manager:SPManager)
    
    
    /// 开始调用打包动画(此方法调用次数和打包动画数量有关,每次调用打包都会调用此代理)
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spWillPackageAnimation(_ spview:UIView,_ manager:SPManager)
    
    
    /// 本地打包动画调用结束(此方法调用次数和打包动画数量有关,每次调用打包都会调用此代理)
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    ///   - param: 动画参数 SPBaseParam的子类:[SPAlphaParam,SPSlideParam,SPScaleParam,SPFoldParam,SPBubbleParam,SPMaskParam,SPRotationParam,SPCustomParam]
    func spDidPackageAnimation(_ spview:UIView,_ manager:SPManager,_ param:SPBaseParam)

    
    /// 将要开始动画流程
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spWillBegin(_ spview:UIView,_ manager:SPManager)

    
    /// 将要(根据上一步拿到的打包参数)获取动画对象
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spWillGetAnimations(_ spview:UIView,_ manager:SPManager)
    
    
    /// 已经获取动画对象
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spDidGetAnimations(_ spview:UIView,_ manager:SPManager)
    
    
    /// 动画对象获取完毕,且分组完毕,将要提交动画
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    ///   - animations: 属性动画对象数组
    ///   - maskAnimations: path属性动画对象数组
    func spWillCommit(_ spview:UIView,_ manager:SPManager,_ animations:[CAAnimation],_ maskAnimations:[CAAnimation])
    
    
    /// 动画已经提交,但有可能还未执行(如果存在延迟调用)
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spDidCommited(_ spview:UIView,_ manager:SPManager)
    
    /// 动画已经执行
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    ///   - mark: 辅助参数
    func spAnimationDidRun(_ spview:UIView,_ manager:SPManager,_ mark:Any)
    
    
    /// 开始处理背景(此代理可以认为是和动画提交在同一时间执行的,只不过因为都在主线程,所以一定有先后,但绝对时间上可以认为是同时调用)
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spWillDoBackground(_ spview:UIView,_ manager:SPManager)
    
    
    /// 背景view已经被添加到inView,需要注意的是在此动画执行前顺序上会先执行SPBackgroundProtocol协议的对应方法
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    ///   - backgroundView: 背景view
    ///   - index: 背景view下标
    func spBackgroundDidAddedToView(_ spview:UIView,_ manager:SPManager,_ backgroundView:UIView,_ index:Int)
    
    
    /// 所有背景view都已被添加到inView上,此时可以在此代理中做一些背景的处理,比如设置位置,定义动画等
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spBackgroundDidAddedAll(_ spview:UIView,_ manager:SPManager)
    
    
    /// 默认背景已经被添加到inView并且已提交默认动画,此代理和自定义背景的执行与否是互斥的
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spDefaultBackgroundDidAddedToViewAndCommited(_ spview:UIView,_ manager:SPManager)
    
    
    /// 默认背景提交的动画已经执行
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    func spDefaultBackgroundAnimationDidRun(_ spview:UIView,_ manager:SPManager)
    
    
    /// 动画已经开始,此代理只在主动画起作用
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    ///   - anim: 动画对象
    func animationDidStart(_ spview:UIView,_ manager:SPManager,_ anim: CAAnimation?)
    
    
    /// 动画已经结束,需要注意的是,如果动画被中断的话也会调用此代理,如如果你在上一次动画完成之前多次调用动画,会直接调用此函数停止执行
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - manager: 动画管理类
    ///   - anim: 动画对象
    ///   - flag: 动画是否已正常完成
    ///   - error: 动画完成错误信息
    func spAnimationDidStop(_ spview:UIView,_ manager:SPManager,_ anim: CAAnimation?, finished flag: Bool,_ error:NSError?)
}


/// 背景代理
public protocol SPBackgroundProtocol:NSObjectProtocol {
    
    /// 获取背景view数量
    /// - Parameter spview: 动画目标类
    func backgroundCount(_ spview:UIView) -> Int
    
    /// 根据下标 返回背景view
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - index: 下标
    func backgroundViewForIndex(_ spview:UIView,index:Int) -> UIView
    
    
    /// 默认背景的点击事件代理,如果未使用默认背景则不调用此代理
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - background: 背景对象
    func backgroundTouch(_ spview:UIView,_ background:UIView) -> Bool
}



/// 弹窗管理类
public class SPManager:NSObject{

    /// 弹窗阶段
    public var step : SPStepType = .none
    /// 动画目标类
    public var target : UIView?
    /// 容器视图
    public var inView : UIView? = UIApplication.shared.keyWindow
    /// 弹窗参数
    public var showParam : SPParam = SPParam.init()
    /// 弹窗参数
    public var hideParam : SPParam = SPParam.init()
    
    /// 打包动画对象数组
    public var packageParams = [Any]()
    /// 自定义背景view数组,自定义背景对象将存在此数组中
    public var backgrounds : [UIView] = [UIView]()
    
    /// 当前是否正在执行动画,同一动画对象不可以在同一时间同时执行多次
    public var animating : Bool = false

    public var dragManager : SPDragManager = SPDragManager.init()
    
    /// 打包动画: 无动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    public func spNoAnimation(_ closure: (_ make: SPAlphaParam ) -> Void = {_ in }) {
        let param = SPAlphaParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .alpha
        param.from = self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        self.finish(SPParam.init(0.0))
    }
    
    
    /// 打包动画: 透明度动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spAlphaAnimation(_ closure: (_ make: SPAlphaParam ) -> Void = {_ in }) -> SPManager {
        let param = SPAlphaParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .alpha
        param.from = (self.step == .show) ? 0.0 : self.target?.alpha ?? 0.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    
    /// 打包动画: 位置动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spSlideAnimation(_ closure: (_ make: SPSlideParam ) -> Void = {_ in }) -> SPManager {
        let param = SPSlideParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .slide
        param.slideDirection = .toTop
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    /// 打包动画: 缩放动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spScaleAnimation(_ closure: (_ make: SPScaleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPScaleParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .scale
        param.from = (self.step == .show) ? 0.0 : 1.0
        param.to = (self.step == .show) ? 1.0 : 0.0
        closure(param)
        if param.values.count == 0 && param.spring {
            param.values.append(0.0)
            param.values.append(1.2)
            param.values.append(0.9)
            param.values.append(1.0)
        }
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    /// 打包动画: 折叠动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spFoldAnimation(_ closure: (_ make: SPFoldParam ) -> Void = {_ in }) -> SPManager {
        let param = SPFoldParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .fold
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.unfoldDirection = .toBottom
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    /// 打包动画: 泡泡动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spBubbleAnimation(_ closure: (_ make: SPBubbleParam ) -> Void = {_ in }) -> SPManager {
        let param = SPBubbleParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .bubble
        param.pinPoint = self.target?.center ?? CGPoint.zero
        param.targetSize = self.target?.frame.size ?? CGSize.zero
        param.bubbleDirection = .toLeftBottom
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    /// 打包动画: 旋转动画,一般不单独用
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spRotationAnimation(_ closure: (_ make: SPRotationParam ) -> Void = {_ in }) -> SPManager {
        let param = SPRotationParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .rotation
        param.from = (self.step == .show) ? 0.0 : Double.pi * 2.0
        param.to = (self.step == .show) ? Double.pi * 2.0 : 0.0
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    
    /// 打包动画: 遮罩动画
    /// - Parameter closure: 打包自定义动画参数闭包,当前类型动画的自定义可查看闭包参数中的属性
    /// - Returns: 动画管理类,可链式调用多个动画自由组合
    public func spMaskAnimation(_ closure: (_ make: SPMaskParam ) -> Void = {_ in }) -> SPManager {
        let param = SPMaskParam()
        self.target?.spDelegate?.spWillPackageAnimation(self.target ?? UIView(), self)
        param.target = self.target
        param.inView = self.inView
        param.type = .mask
        param.from = UIBezierPath.init(rect: CGRect.zero)
        param.to = UIBezierPath.init(rect: CGRect.zero)
        closure(param)
        self.packageParams.append(param)
        self.target?.spDelegate?.spDidPackageAnimation(self.target ?? UIView(), self, param)
        return self
    }
    
    /// 打包完成: 调用打包动画链后需要调用打包完成开始执行动画
    /// - Parameter param: 弹窗参数,控制弹窗一些基本参数,可查看参数中的属性
    public func finish(_ param:SPParam? = SPParam.init(-1)) {
        if (param?.duration ?? -1) < 0.0 {
            if self.step == .show {
                self.showParam = SPParam.init()
            }else{
                self.hideParam = SPParam.init(self.showParam.duration)
            }
        }else{
            if self.step == .show {
                self.showParam = param ?? SPParam.init()
            }else{
                self.hideParam = param ?? SPParam.init()
            }
        }
        self.target?.spMain(self)
    }
}

/// 弹窗管理类
public class SPDragManager:NSObject{
    var beginFrame:CGRect = CGRect.zero
    var endFrame:CGRect = CGRect.zero
    var beginSelfPoint:CGPoint = CGPoint.zero
    var beginSuperPoint:CGPoint = CGPoint.zero
    var dismissDistance:CGFloat = -1
    var direction:SPDirection = .none
}

extension UIView:SPDataSource,SPDelegate,SPBackgroundProtocol,CAAnimationDelegate{
  
    
    /// 显示弹窗入口函数
    /// - Parameter inView: 将弹窗弹到那个view上
    /// - Returns: 弹窗管理类
    public func spshow(_ inView: UIView? = UIApplication.shared.keyWindow) -> SPManager {
        self.spManager.inView = inView
        self.spManager.step = .show
        self.spManager.target = self
        self.spDataSource = self
        self.spDelegate = self
        self.spBackgroundDelegate = self
        self.spManager.packageParams.removeAll()
        self.ending = SPEnding()
        self.spDelegate?.spInited(self, self.spManager)
        return self.spManager
    }
    

    /// 隐藏弹窗入口函数
    /// - Returns: 弹窗管理类
    public func sphide() -> SPManager {
        self.spManager.step = .hide
        self.spManager.target = self
        self.spDataSource = self
        self.spDelegate = self
        self.spBackgroundDelegate = self
        self.spManager.packageParams.removeAll()
        self.ending = SPEnding()
        self.spDelegate?.spInited(self, self.spManager)
        return self.spManager
    }
    
    
    /// 动画初始化完毕,开始执行
    /// - Parameter manager: 弹窗管理类
    func spMain(_ manager:SPManager){
        
        /// 将要开始执行动画操作
        self.spDelegate?.spWillBegin(self, self.spManager)
        
        /// 如果无inView,动画直接结束
        if self.spManager.inView == nil {
            self.spDelegate?.spAnimationDidStop(self, self.spManager, nil, finished: false, NSError.init(domain: "inView is null", code: 100, userInfo: nil))
            #if DEBUG
            assert(false, "inView can't be nil")
            #endif
            return
        }
        
        /// 如果正在执行动画则不执行事务
        if self.spManager.animating {
            self.spDelegate?.spAnimationDidStop(self, self.spManager, nil, finished: false, NSError.init(domain: "animating", code: 101, userInfo: nil))
            return
        }
        
        /// 根据打包参数获取动画类型和CAAnimation对象
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
        
        /// 将CAAnimation对象分组
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
        
        
        /// 处理背景
        if self.spManager.step == .show{
        
            self.spDelegate?.spWillDoBackground(self, self.spManager)
            
            let backgroundCount = self.spBackgroundDelegate?.backgroundCount(self) ?? 0
            
            /// 优先使用自定义多背景,如未使用,则使用默认背景
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
                /// 默认背景为UIButton,如此背景被替换则需要使用者自己实现背景点击事件
                if self.spManager.showParam.backgroundView != nil{
                    self.spManager.showParam.backgroundView?.alpha = 0.0
                    self.spManager.showParam.backgroundView?.frame = self.spManager.inView?.bounds ?? sb
                    if let bk = self.spManager.showParam.backgroundView as? UIButton {
                        bk.addTarget(self, action: #selector(defaultBackgroundClick(ins:)), for: .touchUpInside)
                    }
                    self.spManager.inView?.addSubview(self.spManager.showParam.backgroundView!)
                    UIView.animate(withDuration: self.spManager.showParam.duration, delay: self.spManager.showParam.delay, options: UIViewAnimationOptions.curveEaseOut) {
                        self.spManager.showParam.backgroundView?.alpha = 1.0
                        self.spDelegate?.spDefaultBackgroundAnimationDidRun(self, self.spManager)
                    } completion: { (finish) in}
                    self.spDelegate?.spDefaultBackgroundDidAddedToViewAndCommited(self, self.spManager)
                }
            }
        }else{
            if self.spManager.backgrounds.count == 0 && self.spManager.showParam.backgroundView?.superview != nil {
                UIView.animate(withDuration: self.spManager.hideParam.duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut) {
                    self.spManager.showParam.backgroundView?.alpha = 0.0
                } completion: { (finish) in
                    self.spManager.showParam.backgroundView?.removeFromSuperview()
                }
            }
        }
        
        /// 处理图层
        if animations.count > 0 || maskAnimations.count > 0 {
            if self.superview == nil {
                self.spManager.inView?.addSubview(self)
            }
        }
        
        /// 提交动画
        var duration = 0.3
        var delay = 0.0
        if self.spManager.step == .show {
            duration = self.spManager.showParam.duration
            delay = self.spManager.showParam.delay
        }else{
            duration = self.spManager.hideParam.duration
            delay = self.spManager.hideParam.delay
        }
        if animations.count > 0 {
            
            let group = self.spAnimationGroup()
            group.animations = animations
            group.duration = duration
            group.delegate = self
            /// delay调用
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                self.spManager.animating = true
                self.layer.removeAllAnimations()
                self.layer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
                self.spDelegate?.spAnimationDidRun(self, self.spManager, "normal")
            }
        }
        
        if maskAnimations.count > 0 {
            let group = self.spAnimationGroup()
            group.animations = maskAnimations
            group.duration = duration
            group.delegate = self
            /// delay调用
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                self.spManager.animating = true
                self.shapeLayer.removeAllAnimations()
                self.shapeLayer.add(group, forKey: manager.step == .show ? "spshow" : "sphide")
                self.spDelegate?.spAnimationDidRun(self, self.spManager, "mask")
            }
        }
        
        /// 动画已操作提交但可能由于延时调用而未被真正执行
        self.spDelegate?.spDidCommited(self, self.spManager)
        
        
    }
    
    /// 默认背景点击
    @objc func defaultBackgroundClick(ins:UIButton){
        
        /// 使用者可通过重写 backgroundTouch 方法实现背景自定义点击事件
        if self.spBackgroundDelegate?.backgroundTouch(self, self.spManager.showParam.backgroundView ?? UIView.init()) == true {
            
            self.sphide().spAlphaAnimation { (param) in
                param.to = 0.0
            }.finish(self.spManager.hideParam)
        }
    }
    
    
    /// CAAnimation代理
    /// - Parameter anim: 动画对象
    public func animationDidStart(_ anim: CAAnimation){
        self.spDelegate?.animationDidStart(self, self.spManager, anim)
    }
    
    
    /// CAAnimation代理
    /// - Parameters:
    ///   - anim: 动画对象
    ///   - flag: 动画是否已成功执行
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
            
            var dragDirections:[SPDirection] = []
            for (_,dir) in self.spManager.showParam.dragDirections.enumerated() {
                if dir == .toTop || dir == .toLeft || dir == .toBottom || dir == .toRight {
                    dragDirections.append(dir)
                }
            }
            if dragDirections.count > 0 {
                self.spManager.showParam.dragDirections = dragDirections
                let dragGes:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragGesAction(ins:)))
                self.addGestureRecognizer(dragGes)
                self.spDragGes = dragGes
            }
        }else{
            if self.spManager.showParam.backgroundView?.superview != nil {
                self.spManager.showParam.backgroundView?.removeFromSuperview()
            }
            self.alpha = 1.0
            self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            self.layer.contentsScale = 1.0
            self.removeFromSuperview()
            self.spManager = SPManager.init()
        }
    }
    
    
    @objc func dragGesAction(ins:UIPanGestureRecognizer){
        
        let selfPoint = ins.location(in: self)
        let superPoint = ins.location(in: self.superview)
        
        if (ins.state == .began) {
            
            ///拖动期间不允许点击背景
            if self.spManager.showParam.backgroundView?.superview != nil{
                self.spManager.showParam.backgroundView?.isUserInteractionEnabled = false
            }
            
            ///最小拖动距离
            if (self.spManager.dragManager.dismissDistance <= 0) {
                self.spManager.dragManager.dismissDistance = 100.0
            }
            
            self.spManager.dragManager.beginSelfPoint = selfPoint
            self.spManager.dragManager.beginSuperPoint = superPoint
            self.spManager.dragManager.beginFrame = self.frame
            
        }else if(ins.state == .changed){
            
            ///识别拖拽方向
            if self.spManager.dragManager.direction == .none {
                let min = 10.0
                let x = selfPoint.x - self.spManager.dragManager.beginSelfPoint.x
                let y = selfPoint.y - self.spManager.dragManager.beginSelfPoint.y
                let absx = fabs(Double(x))
                let absy = fabs(Double(y))
                var bframe = self.spManager.dragManager.beginFrame
                let sframe = self.superview?.frame ?? CGRect.zero
                ///到达拖动识别长度
                if absx >= min || absy >= min{
                    if absx > absy {
                        if x > 0.0 {
                            self.spManager.dragManager.direction = .toRight
                            bframe.origin.x = sframe.size.width
                            self.spManager.dragManager.endFrame = bframe
                        }else{
                            self.spManager.dragManager.direction = .toLeft
                            bframe.origin.x = sframe.size.width - bframe.size.width
                            self.spManager.dragManager.endFrame = bframe
                        }
                    }else{
                        if y > 0.0 {
                            self.spManager.dragManager.direction = .toBottom
                            bframe.origin.y = sframe.size.height
                            self.spManager.dragManager.endFrame = bframe
                        }else{
                            self.spManager.dragManager.direction = .toTop
                            bframe.origin.y = sframe.size.height - bframe.size.height
                            self.spManager.dragManager.endFrame = bframe
                        }
                    }
                }
                
                let dir = self.spManager.dragManager.direction
                if dir == .toLeft || dir == .toBottom || dir == .toRight || dir == .toTop {
                    self.spManager.dragManager.beginSelfPoint = selfPoint
                    self.spManager.dragManager.beginSuperPoint = superPoint
                }
                
            }else{
                
                ///拖动
                let originx = self.spManager.dragManager.beginFrame.origin.x
                let originy = self.spManager.dragManager.beginFrame.origin.y
                
                var x = superPoint.x - self.spManager.dragManager.beginSelfPoint.x
                var y = superPoint.y - self.spManager.dragManager.beginSelfPoint.y
                
                switch self.spManager.dragManager.direction {
                case .toTop:
                    x = originx
                    let distancey = y - originy
                    if distancey > 0.0 {
                        y = originy
                    }
                    break
                case .toBottom:
                    x = originx
                    let distancey = y - originy
                    if distancey < 0.0 {
                        y = originy
                    }
                    break
                case .toLeft:
                    y = originy
                    let distancex = x - originx
                    if distancex > 0.0 {
                        x = originx
                    }
                    break
                case .toRight:
                    y = originy
                    let distancex = x - originx
                    if distancex < 0.0 {
                        x = originx
                    }
                    break
                default:
                    break
                }
                self.frame = CGRect.init(x: x, y: y, width: self.frame.size.width, height: self.frame.size.height)
                
            }
            
        }else{
            ///计算距离
            let distanceh = fabs(self.spManager.dragManager.beginFrame.origin.x - self.spManager.dragManager.endFrame.origin.x)
            let distancev = fabs(self.spManager.dragManager.beginFrame.origin.y - self.spManager.dragManager.endFrame.origin.y)
            
            let distancex = fabs(self.spManager.dragManager.beginFrame.origin.x - self.frame.origin.x)
            let distancey = fabs(self.spManager.dragManager.beginFrame.origin.y - self.frame.origin.y)
            
            var percent = 1.0
            if self.spManager.dragManager.direction == .toLeft || self.spManager.dragManager.direction == .toRight{
                percent = Double(distancex / distanceh)
            }else if self.spManager.dragManager.direction == .toTop || self.spManager.dragManager.direction == .toBottom{
                percent = Double(distancey / distancev)
            }else{
                
            }
            
            let pd = percent * self.spManager.showParam.duration
            let dur = percent < 0.3 ? pd : 1.0 - pd
            
            if percent > 0.3 {

                let param = SPParam.init(dur)
                self.sphide().spSlideAnimation {[weak self] (param) in
                    param.slideDirection = self?.spManager.dragManager.direction ?? .toBottom
                    param.to = self?.spGetCenter(self?.spManager.dragManager.endFrame ?? CGRect.zero) ?? CGPoint.zero
                }.finish(param)
                
                ///拖动期间不允许点击背景
                if self.spManager.showParam.backgroundView?.superview != nil{
                    self.spManager.showParam.backgroundView?.isUserInteractionEnabled = true
                }
                
            }else{
                UIView.animate(withDuration: dur) {
                    self.frame = self.spManager.dragManager.beginFrame
                } completion: { (finish) in
                    ///拖动期间不允许点击背景
                    if self.spManager.showParam.backgroundView?.superview != nil{
                        self.spManager.showParam.backgroundView?.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    /*
     _______________功能模块分割线_______________________
     _______________########_______________________
     ______________##########_______________________
    ______________############_____________________
    ______________#############____________________
    _____________##__###########___________________
    ____________###__######_#####__________________
    ____________###_#######___####_________________
    ___________###__##########_####________________
    __________####__###########_####_______________
    ________#####___###########__#####_____________
    _______######___###_########___#####___________
    _______#####___###___########___######_________
    ______######___###__###########___######_______
    _____######___####_##############__######______
    ____#######__#####################_#######_____
    ____#######__##############################____
    ___#######__######_#################_#######___
    ___#######__######_######_#########___######___
    ___#######____##__######___######_____######___
    ___#######________######____#####_____#####____
    ____######________#####_____#####_____####_____
    _____#####________####______#####_____###______
    ______#####______;###________###______#________
    ________##_______####________####______________
             葱官赐福  百无禁忌
     */

    /// ************************************ SPDataSource 代理方法自实现 ************************************
    
    /// SPDataSource代理方法,参考代理注释-子类重写此方法以实现定制化
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
  
    
    /// SPDataSource代理方法,参考代理注释-子类重写此方法以实现定制化
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
            
            let offset = self.spManager.showParam.offset
            var from = self.calculatePosition(slideParam.slideDirection, step, offset).0
            if slideParam.from != CGPoint.zero {
                from = slideParam.from
            }
            
            var to = self.calculatePosition(slideParam.slideDirection, step, offset).1
            if slideParam.to != CGPoint.zero {
                to = slideParam.to
            }
            
            self.ending?.frame = self.spGetFrame(self.frame.size, to)
            
            animation = CAAnimation.spPositionAnimation(values: [from,to], duration: slideParam.duration)
            
        }else if type == .scale,let scaleParam = param as? SPScaleParam {
            
            let anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            self.spSetAnchorPoint(point: anchorPoint, forView: self)
            self.ending?.anchorPoint = anchorPoint
            
            if scaleParam.values.count > 0 {
                animation = CAAnimation.spScaleAnimation(values: scaleParam.values, duration: scaleParam.duration)
                self.ending?.scale = scaleParam.values.last ?? 1.0
                if step == .hide {
                    scaleParam.values.reverse()
                    self.ending?.scale = scaleParam.values.first ?? 0.0
                }
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
                from = self.calculateFold(foldParam.targetSize, foldParam.unfoldDirection, false)
                to = self.calculateFold(foldParam.targetSize, foldParam.unfoldDirection, true)
            }else if step == .hide{
                from = self.calculateFold(foldParam.targetSize, foldParam.unfoldDirection, true)
                to = self.calculateFold(foldParam.targetSize, foldParam.unfoldDirection, false)
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
            
            self.spSetAnchorPoint(point: anchorPoint, forView: self)
            
            animation = CAAnimation.spScaleAnimation(values: [from,to], duration: bubbleParam.duration)
            
        }else if type == .path,let bubbleParam = param as? SPBubbleParam,bubbleParam.bubbleType == .mask {
            
            var from:CGRect = CGRect.zero
            var to:CGRect = CGRect.zero

            self.frame = self.calculateBubble(bubbleParam.pinPoint, bubbleParam.targetSize, bubbleParam.bubbleDirection).1
            self.ending?.frame = self.frame

            if step == .show {
                from = self.calculateFold(bubbleParam.targetSize, bubbleParam.bubbleDirection, false)
                to = self.calculateFold(bubbleParam.targetSize, bubbleParam.bubbleDirection, true)
            }else if step == .hide{
                from = self.calculateFold(bubbleParam.targetSize, bubbleParam.bubbleDirection, true)
                to = self.calculateFold(bubbleParam.targetSize, bubbleParam.bubbleDirection, false)
            }
            
            let fromPath = UIBezierPath.init(rect: from)
            let toPath = UIBezierPath.init(rect: to)
            animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: bubbleParam.duration)
            
        }else if type == .path,let maskParam = param as? SPMaskParam {
            
            let fromPath = maskParam.from
            let toPath = maskParam.to
            if maskParam.values.count > 0 {
                animation = CAAnimation.spPathAnimation(values: maskParam.values, duration: maskParam.duration)
            }else{
                animation = CAAnimation.spPathAnimation(values: [fromPath,toPath], duration: maskParam.duration)
            }
            
        }else if type == .rotation,let rotationParam = param as? SPRotationParam {

            let from:Double = rotationParam.from
            let to:Double = rotationParam.to
            
            animation = CAAnimation.spRotationAnimation(rotationType: rotationParam.rotationType, values: [from,to], duration: rotationParam.duration)
            
        }else if type == .custom {
            
            animation = self.customAnimationForIndex(spview, step, param, type: type, index: index)
            assert(animation != nil, "please implement customAnimationForIndex method,and return a valid CAAnimation instance")
        }
        
        /// 提交动画
        var duration = 0.3
        if self.spManager.step == .show {
            duration = self.spManager.showParam.duration
        }else{
            duration = self.spManager.hideParam.duration
        }
        animation?.duration = duration
        animation?.delegate = self
    
        return animation
    }
    
    /// SPDataSource代理方法,参考代理注释-子类重写此方法以实现定制化
    public func customAnimationForIndex(_ spview: UIView, _ step: SPStepType, _ param: Any, type: SPBaseAnimationType, index: Int) -> CAAnimation? {
        return nil
    }
    
    
    /// ************************************ SPDelegate 代理方法自实现 ************************************
    
    /// 背景代理: 自定义背景数量-重写此方法以实现自定义背景功能
    /// - Parameter spview: 动画目标类
    /// - Returns: 背景数量
    @objc open func backgroundCount(_ spview: UIView) -> Int {
        return 0
    }
    
    /// 背景代理: 自定义背景view-重写此方法以实现自定义背景功能
    /// - Parameters:
    ///   - spview: 动画目标类
    ///   - index: 下标
    /// - Returns: 背景view
    @objc open func backgroundViewForIndex(_ spview: UIView, index: Int) -> UIView {
        return UIButton.init(type: .custom)
    }
    
    
    /// 背景代理: 默认背景点击事件-重写此方法以实现自定义背景功能
    /// - Parameters:
    ///   - spview:
    ///   - background: 默认背景view对象
    /// - Returns: 是否继续使用对默认背景的动画处理
    @objc open func backgroundTouch(_ spview: UIView, _ background: UIView) -> Bool {
        return true
    }
    
    
    /// ************************************ SPBackgroundProtocol 代理方法自实现 ************************************
    
    @objc open func spInited(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spWillPackageAnimation(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spDidPackageAnimation(_ spview: UIView, _ manager: SPManager, _ param: SPBaseParam) {
        
    }
    
    @objc open func spWillBegin(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spWillGetAnimations(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spDidGetAnimations(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spWillCommit(_ spview: UIView, _ manager: SPManager, _ animations: [CAAnimation], _ maskAnimations: [CAAnimation]) {
        
    }
    
    @objc open func spDidCommited(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spAnimationDidRun(_ spview: UIView, _ manager: SPManager, _ mark: Any) {
        
    }
    
    @objc open func spWillDoBackground(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spBackgroundDidAddedToView(_ spview: UIView, _ manager: SPManager, _ backgroundView: UIView, _ index: Int) {
        
    }
    
    @objc open func spBackgroundDidAddedAll(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spDefaultBackgroundDidAddedToViewAndCommited(_ spview: UIView, _ manager: SPManager) {
        
    }
    
    @objc open func spDefaultBackgroundAnimationDidRun(_ spview: UIView, _ manager: SPManager) {
        
    }
   
    @objc open func animationDidStart(_ spview: UIView, _ manager: SPManager, _ anim: CAAnimation?) {
        
    }
    
    @objc open func spAnimationDidStop(_ spview: UIView, _ manager: SPManager, _ anim: CAAnimation?, finished flag: Bool, _ error: NSError?) {
        
    }
}



/*
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//        ======`-.____`-.___\_____/___.-`____.-*======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//          博主曰:
//                  愿世间再无BUG，祝猿们早日出任CEO，
//                  赢取白富美，走上人生的巅峰！~~~
//        .............................................
*/



/// 绑定属性的key
private let kSpManagerKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kSpManagerKey".hashValue)
private let kSpDataSourceKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kSpDataSourceKey".hashValue)
private let kShowAnimationsKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kShowAnimationsKey".hashValue)
private let kHideAnimationsKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kHideAnimationsKey".hashValue)
private let kEndingKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kEndingKey".hashValue)
private let kDelegateKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kDelegateKey".hashValue)
private let kBackgroundsKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kBackgroundsKey".hashValue)
private let kDragGesKey: UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "kDragGesKey".hashValue)

public extension UIView{
    
    /// 弹窗管理
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
    
    /// 结束值存储
    var ending:SPEnding?{
        get {
            return objc_getAssociatedObject(self, kEndingKey) as? SPEnding
        }
        set {
            objc_setAssociatedObject(self, kEndingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// mask-layer
    var shapeLayer:CAShapeLayer{
        get {
            if self.layer.mask == nil{
                self.layer.mask = CAShapeLayer.init()
            }
            return self.layer.mask as! CAShapeLayer
        }
    }
    
    
    /// 数据源代理
    var spDataSource:SPDataSource?{
        get {
            let spDataSource = objc_getAssociatedObject(self, kSpDataSourceKey) as? SPDataSource
            return spDataSource
        }
        set {
            objc_setAssociatedObject(self, kSpDataSourceKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 事件代理
    var spDelegate:SPDelegate?{
        get {
            return objc_getAssociatedObject(self, kDelegateKey) as? SPDelegate
        }
        set {
            objc_setAssociatedObject(self, kDelegateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    /// 背景代理
    var spBackgroundDelegate:SPBackgroundProtocol?{
        get {
            return objc_getAssociatedObject(self, kBackgroundsKey) as? SPBackgroundProtocol
        }
        set {
            objc_setAssociatedObject(self, kBackgroundsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 拖拽手势
    var spDragGes:UIPanGestureRecognizer?{
        get {
            return objc_getAssociatedObject(self, kDragGesKey) as? UIPanGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, kDragGesKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// 动画组容器
    /// - Returns: 动画组
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
    
    
    /// 根据滑动类型计算滑动的值
    /// - Parameters:
    ///   - slideDirection: 滑动方向
    ///   - step: 弹窗阶段
    ///   - offset: 位置偏移:偏移和方向有关,如方向为.toTop,偏移的y值即为相对于预期目标点的偏移值
    /// - Returns: .0:起始position point;.1:目标position point
    func calculatePosition(_ slideDirection:SPDirection,_ step:SPStepType,_ offset:CGPoint) -> (CGPoint,CGPoint){
        
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
                to = CGPoint.init(x: superw - selfw * 0.5 + offset.x, y: superh * 0.5 + offset.y)
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
    
    
    /// 根据折叠类型计算折叠的值
    /// - Parameters:
    ///   - targetSize: 折叠效果展开后的尺寸
    ///   - unfoldDirection: 展开方向
    ///   - unFold: 展开状态
    /// - Returns: 折叠后的目标frame
    func calculateFold(_ targetSize:CGSize,_ unfoldDirection:SPDirection,_ unFold:Bool) -> CGRect{
        
        let ss = targetSize
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        var w:CGFloat = 0.0
        var h:CGFloat = 0.0
        if unFold == true {
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
    
    
    
    /// 计算泡泡的anchorPoint值和泡泡展开后的rect
    /// - Parameters:
    ///   - pinPoint: 泡泡的基准点
    ///   - targetSize: 泡泡展开后的尺寸
    ///   - bubbleDirection: 泡泡展开尺寸
    /// - Returns: .0:泡泡的anchorPoint ;.1:泡泡的展开 rect
    func calculateBubble(_ pinPoint:CGPoint,_ targetSize:CGSize,_ bubbleDirection:SPDirection) -> (CGPoint,CGRect){
        
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
    
    
    /// 设置某个view的锚点
    /// - Parameters:
    ///   - point: 锚点值
    ///   - forView: 目标view
    func spSetAnchorPoint(point:CGPoint,forView:UIView){
        let oldFrame = forView.frame
        forView.layer.anchorPoint = point
        forView.frame = oldFrame
    }
    
    
    /// 通过view的center 和size 计算 view的frame
    /// - Parameters:
    ///   - size: view 的size
    ///   - center: view 的center
    /// - Returns: view 的frame
    func spGetFrame(_ size:CGSize,_ center:CGPoint) -> CGRect{
        let x = center.x - size.width * 0.5
        let y = center.y - size.height * 0.5
        return CGRect.init(origin: CGPoint.init(x: x, y: y), size: size)
    }
    
    
    /// 通过view的center 和size 计算 view的frame
    /// - Parameters:
    ///   - size: view 的size
    ///   - center: view 的center
    /// - Returns: view 的frame
    func spGetCenter(_ frame:CGRect) -> CGPoint{
        let x = frame.origin.x + frame.size.width * 0.5
        let y = frame.origin.y + frame.size.height * 0.5
        return CGPoint.init(x: x, y: y)
    }
}






/**
 *
 * ━━━━━━神兽出没━━━━━━
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　　　　　┃
 * 　　┃　　　━　　　┃
 * 　　┃　┳┛　┗┳　┃
 * 　　┃　　　　　　　┃
 * 　　┃　　　┻　　　┃
 * 　　┃　　　　　　　┃
 * 　　┗━┓　　　┏━┛Code is far away from bug with the animal protecting
 * 　　　　┃　　　┃    神兽保佑,代码无bug
 * 　　　　┃　　　┃
 * 　　　　┃　　　┗━━━┓
 * 　　　　┃　　　　　　　┣┓
 * 　　　　┃　　　　　　　┏┛
 * 　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　┃┫┫　┃┫┫
 * 　　　　　┗┻┛　┗┻┛
 *
 * ━━━━━━感觉萌萌哒━━━━━━
 */
  
/**
 * 　　　　　　　　┏┓　　　┏┓
 * 　　　　　　　┏┛┻━━━┛┻┓
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃　　　━　　　┃
 * 　　　　　　　┃　＞　　　＜　┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┃...　⌒　...　┃
 * 　　　　　　　┃　　　　　　　┃
 * 　　　　　　　┗━┓　　　┏━┛
 * 　　　　　　　　　┃　　　┃　Code is far away from bug with the animal protecting
 * 　　　　　　　　　┃　　　┃   神兽保佑,代码无bug
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┃
 * 　　　　　　　　　┃　　　┗━━━┓
 * 　　　　　　　　　┃　　　　　　　┣┓
 * 　　　　　　　　　┃　　　　　　　┏┛
 * 　　　　　　　　　┗┓┓┏━┳┓┏┛
 * 　　　　　　　　　　┃┫┫　┃┫┫
 * 　　　　　　　　　　┗┻┛　┗┻┛
 */
  
/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━█████+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */
