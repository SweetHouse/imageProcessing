//
//  GaosimohuViewController.swift
//  图像处理
//
//  Created by 李维峰 on 2020/5/18.
//  Copyright © 2020 李维峰. All rights reserved.
//

import UIKit

class GaosimohuViewController: UIViewController {
    var slider = UISlider()
    var label = UILabel()
    var effectView = UIVisualEffectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 70)
        label.backgroundColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.text = "This is a browser plugin for developers, cross-border workers, and research institutes to secure and speed Internet surfing."
        
        view.addSubview(effectView)
        effectView.frame = view.bounds
        let blurEffect = UIBlurEffect(style: .light)
        effectView.effect = blurEffect

        view.addSubview(slider)
        slider.frame = CGRect(x: 100, y: 500, width: 200, height: 50)
        slider.addTarget(self, action: #selector(valueChange), for: .valueChanged)
    
    }
    @objc func valueChange(){
        effectView.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value))
        effectView.frame = view.bounds
    }

}
