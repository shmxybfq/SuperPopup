//
//  SPParam.swift
//  SuperPopup
//
//  Created by 成丰快运 on 2021/4/10.
//

import UIKit
import Foundation

public class SPMaskParam:SPBaseParam{
    //
    var from : UIBezierPath = UIBezierPath.init()
    //
    var to : UIBezierPath = UIBezierPath.init()
    
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
    // 动画时间
    public var duration : Double = 0.25
    // 动画类型
    public var type:SPPopupType = .none
    // 动画数量
    public var count:Int = 0
    // 类型&动画 数组
    public var typeAnimations = Dictionary<SPBaseAnimationType,CAAnimation>()
}


public class SPParam:NSObject,Codable{
    // 动画时间
    public var duration : Double = 0.25
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
    public init(_ duration:Double = 0.25,_ offset:CGPoint = CGPoint.zero,_ delay:TimeInterval = 0.0) {
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
    /// 选择类型ui-初始化方法
    public init(_ alpha:CGFloat = -1,_ frame:CGRect = CGRect.zero) {
        super.init()
        self.alpha = alpha
        self.frame = frame
    }
}
