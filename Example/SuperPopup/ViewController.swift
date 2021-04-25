//
//  ViewController.swift
//  SuperPopup
//
//  Created by shmxybfq@163.com on 04/10/2021.
//  Copyright (c) 2021 shmxybfq@163.com. All rights reserved.
//

import UIKit
import SuperPopup

class TestModel: NSObject {
    
    var sectionName:String = ""
    
    var data:[String] = []

    init(_ name:String,_ data:[String]) {
        self.sectionName = name
        self.data = data
    }
}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
   

    @IBOutlet weak var tableView: UITableView!
    
    var showed:Bool = false
    
    var dataSource:[TestModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        let base = TestModel.init("基础", ["无动画","渐隐","滑动0","滑动1","缩放","折叠","泡泡","旋转:XYZ","遮罩"])
        let group = TestModel.init("多种自由组合示例", ["渐隐+滑动","滑动+缩放","渐隐+滑动+缩放","滑动+折叠","渐隐泡泡","旋转Z","旋转+遮罩","波纹遮罩"])
        let custom = TestModel.init("基础自定义和扩展自定义", ["参数自定义示例0","参数自定义示例1","参数自定义示例2","扩展自定义0","扩展自定义1","扩展自定义2"])
        
        self.dataSource.append(base)
        self.dataSource.append(group)
        self.dataSource.append(custom)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model:TestModel = self.dataSource[section]
        return model.sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model:TestModel = self.dataSource[section]
        return model.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:TestModel = self.dataSource[indexPath.section]
        let name = model.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        cell?.textLabel?.text = name
        return cell!
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let model:TestModel = self.dataSource[indexPath.section]
        let name = model.data[indexPath.row]
        
        let param = SPParam.init()
        param.duration = 0.5
        
        var popupView:APopupView? = nil
        if name == "无动画" {
            
            popupView = APopupView.creat("popup-1")
            popupView?.spshow().spNoAnimation()
            
        }else if name == "渐隐" {
            
            popupView = APopupView.creat("popup-1")
            //无任何参数写法:
            //popup?.spshow().spAlphaAnimation().finish()
            popupView?.spshow().spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "滑动0" {
            
            popupView = APopupView.creat("popup-1")
            //无任何参数写法:默认水平中间位置,从下至上弹出来,刚好显示出来整个view
            //popup?.spshow().spSlideAnimation().finish()
            popupView?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toTop
                param.to = param.inView?.center ?? param.to
            }).finish(param)
            
        }else if name == "滑动1" {
            
            popupView = APopupView.creat("popup-8")
            //无任何参数写法:默认水平中间位置,从下至上弹出来,刚好显示出来整个view
            //popup?.spshow().spSlideAnimation().finish()
            popupView?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toLeft
                
            }).finish(param)
            
        }else if name == "缩放" {
            
            popupView = APopupView.creat("popup-1")
            popupView?.spshow().spScaleAnimation({ (param) in
                //param.spring = true
            }).finish(param)
            
        }else if name == "折叠" {
            
            popupView = APopupView.creat("popup-5")
            popupView?.frame = CGRect.init(x: 0, y: 100, width: sbw, height: sbw / (1242.0 / 948.0))
            popupView?.spshow().spFoldAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "泡泡" {
            
            popupView = APopupView.creat("popup-6")
            popupView?.spshow().spBubbleAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "旋转:XYZ" {
            
            popupView = APopupView.creat("popup-1")
            popupView?.spshow().spRotationAnimation { (param) in
                param.rotationType = .z
            }.finish(param)
            
        }else if name == "遮罩" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spMaskAnimation { (param) in
                let size = param.target?.bounds.size
                param.from = UIBezierPath.init(ovalIn: CGRect.init(x: (size!.width * 0.5), y: (size!.height * 0.5), width: 0, height: 0))
                param.to = UIBezierPath.init(rect: CGRect.init(origin: CGPoint.zero, size: size!))
            }.finish(param)
            
        }else if name == "渐隐+滑动" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toTop
                param.to = CGPoint.init(x: sbw * 0.5, y: sbh * 0.5)
            }).spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "滑动+缩放" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toBottom
                param.to = CGPoint.init(x: sbw * 0.5, y: sbh * 0.5)
            }).spScaleAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "渐隐+滑动+缩放" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toTop
                param.to = CGPoint.init(x: sbw * 0.5, y: sbh * 0.5)
            }).spAlphaAnimation({ (param) in
                
            }).spScaleAnimation({ (param) in
                
            }).spRotationAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "滑动+折叠" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toTop
                param.to = CGPoint.init(x: sbw * 0.5, y: sbh * 0.5)
            }).spFoldAnimation({ (param) in
                param.targetSize = (param.target?.frame.size)!
                
            }).finish(param)
            
        }else if name == "渐隐泡泡" {
            
            popupView = APopupView.creat("popup-6")
            popupView?.spshow().spBubbleAnimation({ (param) in
                
            }).spFoldAnimation({ (param) in
                param.targetSize = (param.target?.frame.size)!
                
            }).finish(param)
            
        }else if name == "旋转Z" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spRotationAnimation { (param) in
                
            }.finish(param)
            
        }else if name == "旋转+遮罩" {
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spRotationAnimation { (param) in
                
            }.spFoldAnimation({ (param) in
                
            }).finish(SPParam.init(1.5))
            
        }else if name == "波纹遮罩" {
            
            
            popupView = APopupView.creat("popup-2")
            popupView?.spshow().spMaskAnimation { (param) in
                
                let ss = param.target?.bounds.size ?? CGSize.init()
                var paths:[UIBezierPath] = []
                
                for (i) in 0..<8 {
                    let path = UIBezierPath.init()
                    path.move(to: CGPoint.init(x: 0.0, y: ss.height))
                    path.addLine(to: CGPoint.init(x: 0.0, y: ss.height - ss.height * 0.2 * CGFloat(i)))
                    let p0 = CGPoint.init(x: ss.width * 0.33, y: ss.height - ss.height * 0.2 * CGFloat(i) - 34)
                    let p1 = CGPoint.init(x: ss.width * 0.66, y: ss.height - ss.height * 0.2 * CGFloat(i) + 34)
                    let to = CGPoint.init(x: ss.width, y: ss.height - ss.height * 0.2 * CGFloat(i))
                    path.addCurve(to: to, controlPoint1: (i % 2 == 0) ? p0 : p1, controlPoint2: (i % 2 == 0) ? p1 : p0)
                    path.addLine(to: CGPoint.init(x: ss.width, y: ss.height))
                    path.addLine(to: CGPoint.init(x: 0, y: ss.height))
                    path.close()
                    paths.append(path)
                }
                param.values = paths
                
            }.finish(SPParam.init(1.5))
            
        }
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(popupViewTapGes(ins:)))
        popupView?.addGestureRecognizer(tapGes)
        
    }
    
    @objc func popupViewTapGes(ins:UITapGestureRecognizer){
        print("点击弹出")
        if let view = ins.view {
            view.sphide().spSlideAnimation { (param) in
                param.slideDirection = .toBottom
            }.finish()
        }
    }
    
    //1.滑动时offset有问题
    //2.考虑隐藏时动画不同的问题
    //3.缩放动画和spring不能共存
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        
        self.showed = !self.showed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
     
        
    }
}

