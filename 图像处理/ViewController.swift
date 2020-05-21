//
//  ViewController.swift
//  图像处理
//
//  Created by 李维峰 on 2020/5/18.
//  Copyright © 2020 李维峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let msk = LWFMasaikeView(frame: view.bounds,pixView: view)
        msk.animate(duration: 0.5, fromScal: 30, toScal: 1)
        msk.animateCompleted = {
            msk.removeFromSuperview()
        }
        view.addSubview(msk)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = ["高斯模糊","马赛克"]
        for title in titles.enumerated() {
            let btn = UIButton(type: .custom)
            view.addSubview(btn)
            btn.frame.size = CGSize(width: 100, height: 30)
            btn.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: 200 + CGFloat(title.offset) * 40)
            btn.setTitle(title.element, for: .normal)
            btn.backgroundColor = .green
            btn.addTarget(self, action: #selector(ClickOn(btn:)), for: .touchUpInside)
            
        }
        
    }
    @objc func ClickOn(btn:UIButton){
        switch btn.titleLabel?.text {
        case "高斯模糊":
            self.present(test1(), animated: true, completion: nil)
        case "马赛克":
            let tab = test2()
            tab.modalPresentationStyle = .fullScreen
            self.present(tab, animated: true, completion: nil)
        default:
            return
        }
    }

}

