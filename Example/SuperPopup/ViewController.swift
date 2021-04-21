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
        
        let base = TestModel.init("基础动画", ["无动画","渐隐","滑动","缩放","折叠","泡泡","旋转:XYZ","遮罩"])
        let group = TestModel.init("多种自由组合动画", ["渐隐+滑动","滑动+缩放","渐隐+滑动+缩放","滑动+折叠","渐隐泡泡","旋转Z","旋转Z+Y","旋转Z+Y+X","旋转+遮罩","三角形遮罩","圆形遮罩"])
        
        self.dataSource.append(base)
        self.dataSource.append(group)

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
        param.duration = 0.3
        
        var popup:UIView?
        
        if name == "无动画" {
            
            popup = APopupView.creat("popup-1")
            popup?.spshow().spNoAnimation()
            
        }else if name == "渐隐" {
            
            popup = APopupView.creat("popup-1")
            //无任何参数写法:
            //popup?.spshow().spAlphaAnimation().finish()
            popup?.spshow().spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }else if name == "滑动" {
            
            popup = APopupView.creat("popup-1")
            //无任何参数写法:默认水平中间位置,从下至上弹出来,刚好显示出来整个view
            //popup?.spshow().spSlideAnimation().finish()
            popup?.spshow().spSlideAnimation({ (param) in
                param.slideDirection = .toTop
                param.to = param.inView?.center ?? param.to
            }).finish(param)
            
        }else if name == "缩放" {
            
            popup = APopupView.creat("popup-1")
            
        }else if name == "折叠" {
            popup = APopupView.creat("popup-5")
        }else if name == "泡泡" {
            popup = APopupView.creat("popup-6")
        }else if name == "旋转:XYZ" {
            popup = APopupView.creat("popup-1")
        }else if name == "遮罩" {
            popup = APopupView.creat("popup-2")
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

