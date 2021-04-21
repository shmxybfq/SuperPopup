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
    
    let alert = Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as? AlertView

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
    
    
    //1.滑动时offset有问题
    //2.考虑隐藏时动画不同的问题
    //3.缩放动画和spring不能共存
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let param = SPParam.init()
        param.delay = 0
        param.duration = 1
        param.backgroundView = nil
        //滑动时有问题
        param.offset = CGPoint.init(x: 0, y: -(UIScreen.main.bounds.size.height - 200.0) * 0.5)
        
        if self.showed == false{

//            //滑动
//            alert?.spshow(self.view).spSlideAnimation { (param) in
//                param.slideDirection = .toTop
//            }.finish(param)
            
            alert?.spshow(self.view).spRotationAnimation({ (param) in
                param.rotationType = .z
            }).spRotationAnimation({ (param) in
                param.rotationType = .x
            }).spRotationAnimation({ (param) in
                param.rotationType = .y
            }).spScaleAnimation({ (param) in
                
            }).spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }else{
          
//            //滑动
//            alert?.sphide.spSlideAnimation({ (param) in
//                param.slideDirection = .toTop
//                param.to = CGPoint.init(x: self.alert?.center.x ?? 0, y: (self.alert?.center.y ?? 0) - 200)
//            }).spAlphaAnimation({ (param) in
//                param.to = 0.0
//            }).spScaleAnimation({ (param) in
//                param.to = 0.0
//                param.target?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
//            }).finish(param)
            
            alert?.sphide().spRotationAnimation({ (param) in
                param.rotationType = .z
            }).spRotationAnimation({ (param) in
                param.rotationType = .x
            }).spRotationAnimation({ (param) in
                param.rotationType = .y
            }).spScaleAnimation({ (param) in
                
            }).spAlphaAnimation({ (param) in
                
            }).finish(param)
            
        }
        
        self.showed = !self.showed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

