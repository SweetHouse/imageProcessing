//
//  test2.swift
//  图像处理
//
//  Created by 李维峰 on 2020/5/21.
//  Copyright © 2020 李维峰. All rights reserved.
//

import UIKit

class test2: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = test2_1()
        let nav1 = UINavigationController(rootViewController: vc1)
        vc1.title = "马赛克效果1"
        vc1.tabBarItem.tag = 1
        self.addChild(nav1)
        
        let vc2 = test2_1()
        let nav2 = UINavigationController(rootViewController: vc2)
        vc2.title = "马赛克效果2"
        vc2.tabBarItem.tag = 2
        self.addChild(nav2)
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
