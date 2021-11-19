//
//  UIImage-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(Foundation)
    import Foundation
#endif

import CoreGraphics

// =============================================================================
// MARK: - Initialization
// =============================================================================
extension UIImage {

    /// 创建`UIImage`的时候，可以直接是`UIImage("logo")`
    convenience public init?(_ imageName: String) {
        self.init(named: imageName)
    }

    /// 用于绘制一张图并以 UIImage 的形式返回
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: 要绘制的图片的 size，宽或高均不能为 0
    ///   - opaque: 图片是否不透明，YES 表示不透明，NO 表示半透明, 默认是 不透明
    ///   - scale: 图片的倍数，0 表示取当前屏幕的倍数, 默认0
    public static func ldd_imageWith(_ color: UIColor, size: CGSize, opaque: Bool = true, scale: CGFloat = 0) -> UIImage? {
        guard size != .zero else { return nil }

        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 截图View的一部分，(⚠️⚠️未单元测试)
    ///
    /// - Parameters:
    ///   - view: 要被截图的view
    ///   - frame: 要截图的范围
    static func ldd_snapshotFromView(_ view: UIView, at frame: CGRect) -> UIImage? {
        if view.bounds.equalTo(.zero) { return nil }

        // 1、先根据 view，生成 整个 view 的截图
        UIGraphicsBeginImageContextWithOptions(view.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)

        guard let wholeImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }

        // 2、如果 frame 和 bounds 一样，只要返回 wholeImage 就好。
        if view.bounds.size == frame.size {
            return wholeImage
        }

        // 3、根据 view 的图片。生成指定位置大小的图片。
        let scale = UIScreen.main.scale
        let imageToExtractFrame = frame.applying(CGAffineTransform(scaleX: scale, y: scale))

        if let imageCG = wholeImage.cgImage?.cropping(to: imageToExtractFrame) {
            return UIImage(cgImage: imageCG, scale: scale, orientation: .up)
        }
        return nil
    }

    /// 改变图片的颜色
    /// - Parameter color: 要改变成什么颜色
    func ldd_changWithColor(_ color: UIColor) -> UIImage? {
        guard size != .zero else { return nil }

        UIGraphicsBeginImageContextWithOptions(self.size, true, self.scale)

        UIGraphicsBeginImageContext(self.size)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    ///  切割出在指定位置中的图片，⚠️⚠️似乎有问题，未单元测试
    /// - Parameter rect: 要切割的rect
    /// - Returns:  切割后的新图片
    func ldd_imageWithClipped(_ rect: CGRect) -> UIImage? {
        // 判断一个 CGSize 是否合法（例如不带无穷大的值、不带非法数字）
        if rect.isEmpty || rect.isNull || rect.isInfinite {
            return nil
        }

        // 要裁剪的区域比自身大，所以不用裁剪直接返回自身即可
        if self.size.rect.contains(rect) {
            return self
        }

        // 由于CGImage是以pixel为单位来计算的，而UIImage是以point为单位，所以这里需要将传进来的point转换为pixel
        let s = self.scale
        let scaledRect = CGRect(rect.x * s, rect.y * s, rect.w * s, rect.h * s)

        guard let cgi = self.cgImage else { return nil }
        guard let newCGI = cgi.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: newCGI, scale: s, orientation: self.imageOrientation)
    }

    /// 根据给定的字符串，生成二维码图片
    /// - Parameter str: 给定的字符串内容
    /// - Returns: 返回生成的图片，注意，可能为`nil`
    static func generateQRCode(str: String) -> UIImage? {
        if str.isEmpty { return nil }

        // let data = str.data(using: String.Encoding.ascii)
        let data = str.data(using: String.Encoding.utf8)

        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")

        let transform = CGAffineTransform(scaleX: 9, y: 9)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }

        return UIImage(ciImage: output)
    }

    /// 在当前图片的上下左右增加一些空白（不支持负值）
    /// - Parameters:
    ///   - inset: 要拓展的大小
    ///   - color: 拓展范围的颜色，需要注意的是，由于整个画布都是这个颜色，所以如果图片是透明的，可能有
    ///   造成意料之外的结果，默认是纯白色
    /// - Returns: 拓展后的图片
    func ldd_extensionInsets(_ inset: UIEdgeInsets, color: UIColor = UIColor.white) -> UIImage? {
        let w = self.size.width + inset.left + inset.right
        let h = self.size.height + inset.top + inset.bottom
        let tempSize = CGSize(width: w, height: h)

        var opaque = false
        if let alphaInfo = self.cgImage?.alphaInfo {
            opaque = alphaInfo == .last || alphaInfo == .first || alphaInfo == .none
        }

        UIGraphicsBeginImageContextWithOptions(tempSize, opaque, self.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: tempSize))

        self.draw(at: CGPoint(x: inset.left, y: inset.top))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
