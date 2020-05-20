//
//  MasaikeViewController.swift
//  图像处理
//
//  Created by 李维峰 on 2020/5/18.
//  Copyright © 2020 李维峰. All rights reserved.
//

import UIKit

class MasaikeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let sw = UISwitch(frame: CGRect(x: 10, y: 100, width: 55, height: 55))
        view.addSubview(sw)
        let sw2 = UISwitch(frame: CGRect(x: 10, y: 200, width: 55, height: 55))
        view.addSubview(sw2)
        let sw3 = UISwitch(frame: CGRect(x: 10, y: 300, width: 55, height: 55))
        view.addSubview(sw3)
        
//        let imgv = UIImageView(image: UIImage(named: "Image"))
//        imgv.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
//        view.addSubview(imgv)

        
        let msk = LWFMasaikeView(frame: view.bounds,pixView: view)
        msk.animate(duration: 0.5, fromScal: 50, toScal: 1)
        msk.animateCompleted = {
            msk.removeFromSuperview()
        }
        view.addSubview(msk)
        
        
        
    }
}






