
//
//  LWFMasaikeView.swift
//  图像处理
//
//  Created by 李维峰 on 2020/5/18.
//  Copyright © 2020 李维峰. All rights reserved.
//

import UIKit
typealias block = ()->Void
class LWFMasaikeView: UIView {

    private lazy var imageView:UIImageView = {
        let imgv = UIImageView(frame: self.bounds)
        return imgv
    }()
    private var pixelImage:UIImage!//截屏
    private var displayLink:CADisplayLink?//定时器
    private var fromScal:CGFloat = 0
    private var toScal:CGFloat = 0
    private var addSubtrat:CGFloat = 0//每次刷新变化量
    public var animateCompleted:block?//动画完成
    var fps:Int = 40//刷新率

    public func animate(duration:CGFloat,fromScal:CGFloat,toScal:CGFloat)->Void{
        self.fromScal = fromScal
        self.toScal = toScal
        self.addSubtrat = (toScal - fromScal)/duration/CGFloat(fps)
    }
    
    @objc private func pix(){
        DispatchQueue.main.async {
            self.fromScal = self.fromScal + self.addSubtrat
            self.setNeedsDisplay()
            if ((self.fromScal >= self.toScal) && (self.addSubtrat > 0)) || ((self.fromScal <= self.toScal) && (self.addSubtrat < 0)){
                self.displayLink?.isPaused = true
                self.displayLink?.remove(from: .main, forMode: .common)
                self.displayLink?.invalidate()
                if self.animateCompleted != nil {
                    self.animateCompleted!()
                }
            }
        }
    }

    convenience init(frame:CGRect,pixView:UIView){
        self.init(frame:frame)
        self.addSubview(imageView)
        pixelImage = convertViewToImage(view: pixView)
        
        displayLink = CADisplayLink(target: self, selector: #selector(pix))
        displayLink?.preferredFramesPerSecond = fps
        displayLink?.add(to: .main, forMode: .common)
    }

    /// 控件转图片
    private func convertViewToImage(view:UIView?)->UIImage?{
        UIGraphicsBeginImageContextWithOptions((view?.bounds.size)!,false, UIScreen.main.scale);
        view?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    ///
    override func draw(_ rect: CGRect) {
        var image: CIImage? = CIImage(cgImage: (pixelImage?.cgImage)!)
        // Affine
        let affineClampFiletr = CIFilter(name: "CIAffineClamp")
        affineClampFiletr?.setValue(image, forKey: kCIInputImageKey)
        let xform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        affineClampFiletr?.setValue(xform, forKey: "inputTransform")
        // Pixellate
        let pixellateFilter = CIFilter(name: "CIPixellate")
        pixellateFilter?.setDefaults()
        pixellateFilter?.setValue(affineClampFiletr?.outputImage, forKey: kCIInputImageKey)
        pixellateFilter?.setValue(self.fromScal, forKey: "inputScale")
//        let center = CGPoint(x: image?.extent.size.width ?? 0, y: image?.extent.size.height ?? 0)
//        pixellateFilter?.setValue(center, forKey: "inputCenter")
//         Crop
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter?.setDefaults()
        cropFilter?.setValue(pixellateFilter?.outputImage, forKey: kCIInputImageKey)
        cropFilter?.setValue(CIVector(x: 0, y: 0, z: self.pixelImage.size.width, w: self.pixelImage.size.height), forKey: "inputRectangle")
        
        
        //TODU:加上crop可以全屏打了，但是tm坐标又不好定位了，还是用CRPixellatedView集成吧...始终做不到他那种流畅的效果
        image = cropFilter?.outputImage
        let context = CIContext(options: nil)
        let imgRef = context.createCGImage(image ?? CIImage(), from: image?.extent ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height * 3))

        if let imgRef = imgRef {
            imageView.image = UIImage(cgImage: imgRef)
        }
        super.draw(rect)
    }
}






    
