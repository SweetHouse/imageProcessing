
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
    private var pixelImage:UIImage!//码图
    private var displayLink:CADisplayLink?//定时器
    private var fromScal:CGFloat = 0
    private var toScal:CGFloat = 0
    private var addSubtrat:CGFloat = 0//变化值
    public var animateCompleted:block?//动画完成

    public func animate(duration:CGFloat,fromScal:CGFloat,toScal:CGFloat)->Void{
        self.fromScal = fromScal
        self.toScal = toScal

        displayLink = CADisplayLink(target: self, selector: #selector(pix))
        displayLink?.preferredFramesPerSecond = 30
        displayLink?.add(to: .main, forMode: .common)
        self.addSubtrat = (toScal - fromScal)/duration/30
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    convenience init(frame:CGRect,pixView:UIView){
        self.init(frame:frame)
        pixelImage = convertViewToImage(view: pixView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 控件转图片
    /// - Parameter view: 任意uiview控件
    private func convertViewToImage(view:UIView?)->UIImage?{
        UIGraphicsBeginImageContextWithOptions((view?.bounds.size)!,false, UIScreen.main.scale);
        view?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }

    override func draw(_ rect: CGRect) {
        var image: CIImage? = CIImage(cgImage: (pixelImage?.cgImage)!)
        // 去边，不知道为啥无效
//        let clampFilter = CIFilter(name:"CIAffineClamp")
//        clampFilter?.setValue(image, forKey:kCIInputImageKey)

        // Pixellate打码
        let pixellateFilter = CIFilter(name: "CIPixellate")
        pixellateFilter?.setDefaults()
        pixellateFilter?.setValue(image, forKey: kCIInputImageKey)
        pixellateFilter?.setValue(self.fromScal, forKey: "inputScale")
//        let center = CIVector(cgPoint: CGPoint(x: (image?.extent.size.width ?? 0) / 2.0, y: (image?.extent.size.height ?? 0) / 2.0))
//        pixellateFilter?.setValue(center, forKey: "inputCenter")

        // Crop裁剪（不裁剪打码图片尺寸会不停伸缩,tm裁剪了又不好衔接）
//        let cropFilter = CIFilter(name: "CICrop")
//        cropFilter?.setDefaults()
//        cropFilter?.setValue(pixellateFilter?.outputImage, forKey: kCIInputImageKey)
//        cropFilter?.setValue(CIVector(x: 0, y: 0, z: pixelImage.size.width, w: pixelImage.size.height), forKey: "inputRectangle")

        image = pixellateFilter?.outputImage

        let context = CIContext(options: nil)
        let imgRef = context.createCGImage(image ?? CIImage(), from: image?.extent ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 3, height: UIScreen.main.bounds.height * 3))

        if let imgRef = imgRef {
            imageView.image = UIImage(cgImage: imgRef)
        }
        super.draw(rect)
    }
    
        ///适配图片尺寸
    //    private func resizeImage(image:UIImage,contentMode:ContentMode,bounds:CGSize,quality:CGInterpolationQuality)->UIImage{
    //        let horizontalRatio = bounds.width / image.size.width;
    //        let verticalRatio = bounds.height / image.size.height;
    //        var ratio:CGFloat = 0
    //
    //        switch (contentMode) {
    //            case .scaleAspectFill:
    //                ratio = max(horizontalRatio, verticalRatio);
    //            case .scaleAspectFit:
    //                ratio = min(horizontalRatio, verticalRatio);
    //            default:
    //                ratio = 1
    //        }
    //
    //        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio);
    //
    //        var drawTransposed:Bool = false
    //
    //        switch (image.imageOrientation) {
    //            case .rightMirrored:
    //                drawTransposed = true;
    //            default:
    //                drawTransposed = false;
    //        }
    //
    //        var transform:CGAffineTransform = .identity;
    //
    //        switch (image.imageOrientation) {
    //            case .downMirrored:   // EXIF = 4
    //                transform = transform.translatedBy(x: newSize.width, y: newSize.height);
    //                transform = transform.rotated(by: .pi);
    //            case .leftMirrored:   // EXIF = 5
    //                transform = transform.translatedBy(x: newSize.width, y: 0);
    //                transform = transform.rotated(by: .pi/2);
    //            case .rightMirrored:  // EXIF = 7
    //                transform = transform.translatedBy(x: 0, y: newSize.height);
    //                transform = transform.rotated(by: -.pi/2);
    //            default:
    //                print("")
    //
    //        }
    //
    //        switch (image.imageOrientation) {
    //            case .downMirrored:   // EXIF = 4
    //                transform = transform.translatedBy(x: newSize.width, y: 0);
    //                transform = transform.scaledBy(x: -1, y: 1);
    //            case .rightMirrored:   // EXIF = 5
    //                transform = transform.translatedBy(x: newSize.height, y: 0);
    //                transform = transform.scaledBy(x: -1, y: 1);
    //            default:
    //                print("")
    //
    //        }
    //
    //        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral;
    //        let transposedRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width);
    //        let imageRef:CGImage = image.cgImage!
    //
    //        let bitmap:CGContext = CGContext(data: nil,
    //                                         width: Int(newRect.size.width),
    //                                         height: Int(newRect.size.height),
    //                                         bitsPerComponent: imageRef.bitsPerComponent,
    //                                         bytesPerRow: 0,
    //                                         space: imageRef.colorSpace!,
    //                                         bitmapInfo: imageRef.bitmapInfo.rawValue)!
    //
    //        bitmap.concatenate(transform);
    //        bitmap.interpolationQuality = quality;
    //        bitmap.draw(imageRef, in: drawTransposed ? transposedRect : newRect)
    //        draw(self.layer, in: bitmap)
    //
    //        let newImageRef:CGImage = bitmap.makeImage()!
    //        let newImage:UIImage = UIImage(cgImage: newImageRef);
    //
    //        return newImage;
    //    }
}






    
