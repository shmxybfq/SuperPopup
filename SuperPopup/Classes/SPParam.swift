//
//  SPParam.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation


public class SPCustomParam:SPBaseParam{
   
}

public class SPRotationParam:SPBaseParam{
    /// 旋转起始角度
    public var from : Double = 0.0
    //
    public var to : Double = 0.0
    //
    public var rotationType : SPRotationType = .z
}

public class SPMaskParam:SPBaseParam{
    //
    public var from : UIBezierPath = UIBezierPath.init()
    //
    public var to : UIBezierPath = UIBezierPath.init()
    //
    public var values : [UIBezierPath] = []
}

public class SPBubbleParam:SPBaseParam{
    // 基本点
    public var pinPoint : CGPoint = CGPoint.zero
    // 泡泡尺寸
    public var targetSize:CGSize = CGSize.zero
    // 泡泡展开方向
    public var bubbleDirection:SPEightDirection = .toLeftBottom
    // 泡泡形式
    public var bubbleType:SPBubbleType = .scale
}


public class SPFoldParam:SPBaseParam{
    // view尺寸
    public var targetSize:CGSize = CGSize.zero
    // 展开方向
    public var unfoldDirection:SPEightDirection = .none
}

public class SPScaleParam:SPBaseParam{
    // 起始scale值:0.0 - 1.0
    public var from:CGFloat = 1.0
    // 结束scale值:0.0 - 1.0
    public var to:CGFloat = 1.0
    // 是否模仿系统alert弹窗效果
    public var spring:Bool = false
}


public class SPSlideParam:SPBaseParam{
    // 出发点
    public var from:CGPoint = CGPoint.zero
    // 目的点
    public var to:CGPoint = CGPoint.zero
    // 滑动方向
    public var slideDirection:SPEightDirection = .none
}


public class SPAlphaParam:SPBaseParam{
    // 起始alpha值:0.0 - 1.0
    public var from:CGFloat = 1.0
    // 结束alpha值:0.0 - 1.0
    public var to:CGFloat = 1.0
}


public class SPBaseParam:NSObject{
    // 弹框
    public weak var target:UIView?
    // 弹框inView
    public weak var inView:UIView?
    // 动画时间
    public var duration : Double = 0.25
    // 动画类型
    public var type:SPPopupType = .none
    // 动画数量
    public var count:Int = 0
    // 类型&动画 数组
    public var typeAnimations = Dictionary<SPBaseAnimationType,CAAnimation>()
}


public class SPParam:NSObject{
    // 动画时间
    public var duration : Double = 0.3
    // 位置偏移量
    public var offset : CGPoint = CGPoint.zero
    // 延时
    public var delay:TimeInterval = 0.0
    // 背景
    public lazy var backgroundView:UIView? = {() -> UIButton in
        let ins = UIButton.init(type: .custom)
        ins.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return ins;
    }();
    
    /// 选择类型ui-初始化方法
    public init(_ duration:Double = 0.3,_ offset:CGPoint = CGPoint.zero,_ delay:TimeInterval = 0.0) {
        super.init()
        self.duration = duration
        self.offset = offset
        self.delay = delay
    }
}


public class SPEnding:NSObject{
    // 结束透明度
    public var alpha : CGFloat = -1
    // 结束位置
    public var frame : CGRect = CGRect.zero
    
    // 结束缩放系数
    public var scale : CGFloat = -1
    // 结束锚点
    public var anchorPoint : CGPoint = CGPoint.zero
    
    /// 选择类型ui-初始化方法
    public init(_ alpha:CGFloat = -1,_ frame:CGRect = CGRect.zero) {
        super.init()
        self.alpha = alpha
        self.frame = frame
        
    }
}
