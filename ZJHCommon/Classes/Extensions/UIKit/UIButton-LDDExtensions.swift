//
//  UIButton-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
import Foundation
#endif

/// UIButton的布局显示方式
public enum UIButtonLayout {
    /// 图左字右
    case imageLeft
    /// 图右字左
    case imageRight
    /// 图上字下
    case imageTop
    /// 图下字上
    case imageBottom
}

// =============================================================================
// MARK: - DotSyntax
// =============================================================================
public extension UIButton {
    /// Same as `[self setImage:xx forState:(UIControlStateNormal)];`
    @discardableResult
    func imageNormal(_ image: String?) -> Self {
        if let imageName = image, !(imageName.isEmpty) {
            setImage(UIImage(named: imageName), for: .normal)
        } else {
            setImage(nil, for: .normal)
        }
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateNormal)];`
    @discardableResult
    func imageNormal(_ image: UIImage?) -> Self {
        setImage(image, for: .normal)
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateSelected)];`
    @discardableResult
    func imageSelected(_ image: String?) -> Self {
        if let imageName = image, !(imageName.isEmpty) {
            setImage(UIImage(named: imageName), for: .selected)
        } else {
            setImage(nil, for: .selected)
        }
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateSelected)];`
    @discardableResult
    func imageSelected(_ image: UIImage?) -> Self {
        setImage(image, for: .selected)
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateHighlighted)];`
    @discardableResult
    func imageHighlight(_ image: String?) -> Self {
        if let imageName = image, !(imageName.isEmpty) {
            setImage(UIImage(named: imageName), for: .highlighted)
        } else {
            setImage(nil, for: .highlighted)
        }
        return self
    }

    /// Same as `[self setImage:xx forState:(UIControlStateHighlighted)];`
    @discardableResult
    func imageHighlight(_ image: UIImage?) -> Self {
        setImage(image, for: .highlighted)
        return self
    }

    /// Same as `[self setTitle:title forState:UIControlStateNormal];`
    @discardableResult
    func titleNormal(_ title: String?) -> Self {
        setTitle(title, for: .normal)
        return self
    }

    /// Same as `[self setTitle:title forState:UIControlStateSelected];`
    @discardableResult
    func titleSelected(_ title: String?) -> Self {
        setTitle(title, for: .selected)
        return self
    }

    /// Same as `[self setTitleColor:title forState:UIControlStateNormal];`
    @discardableResult
    func titleColorNormal(_ color: UIColor?) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }

    /// Same as `[self setTitleColor:title forState:UIControlStateSelected];`
    @discardableResult
    func titleColorSelected(_ color: UIColor?) -> Self {
        setTitleColor(color, for: .selected)
        return self
    }

    /// Same as `[self setTitle:title forState:UIControlStateNormal];`
    @discardableResult
    func titleNormal(_ title: String?, _ color: UIColor?) -> Self {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        return self
    }
}

// =============================================================================
// MARK: - Action
// =============================================================================
public extension UIButton {
    /// [self addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    func ldd_addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
        self.isExclusiveTouch = true
    }

    /// [self removeTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    func ldd_removeTarget(_ target: Any?, action: Selector?) {
        self.removeTarget(target, action: action, for: .touchUpInside)
    }
}

// =============================================================================
// MARK: - Layout
// =============================================================================
public extension UIButton {

    /// 布局UIButton文字和图标位置，注意:需要**文字**和**图标**同时存在此方法才有效.
    /// 
    /// - Parameters:
    ///   - type: 布局的类型，4种方式:`UIButtonLayout`
    ///   - margin: 文字和图标的间距
    ///
    /// - Note: ⚠️如果调整了Button的`contentVerticalAlignment`包括水平对齐方式，那么使用此方法时可能不是预期
    /// 的结果！算是方法不完善吧
    ///
    /// - See: https://www.jianshu.com/p/b4cb35c41bf0
    func ldd_layoutWith(_ type: UIButtonLayout, margin: CGFloat) {
        guard imageView?.image != nil else { return }
        guard titleLabel?.text != nil else { return }

        let title = self.title(for: .normal) ?? titleLabel?.text ?? ""
        guard !title.isEmpty else { return }

        var imgW = self.imageView!.bounds.size.width
        var imgH = self.imageView!.bounds.size.height

        if imgW <= 0.0 || imgH <= 0.0 {
            imgW = self.imageView!.image!.size.width
            imgH = self.imageView!.image!.size.height
        }

        var labW = self.titleLabel!.bounds.size.width
        let labH = self.titleLabel!.bounds.size.height

        let textSize = (title as NSString).size(withAttributes: [.font: self.titleLabel!.font!])

        let frameSize = CGSize(width: CGFloat(ceilf(Float(textSize.width))),
                               height: CGFloat(ceilf(Float(textSize.height))))

        if labW < frameSize.width {
            labW = frameSize.width
        }

        let kMargin = margin / 2.0

        switch type {
        case .imageLeft:  // 图左字右
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -kMargin, bottom: 0, right: kMargin)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: -kMargin)
        case .imageRight:  // 图右字左
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labW, bottom: 0, right: -labW - kMargin)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imgW - kMargin, bottom: 0, right: imgW + kMargin)
        case .imageTop:  // 图上字下
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: labH + margin, right: -labW)
            titleEdgeInsets = UIEdgeInsets(top: imgH + margin, left: -imgW, bottom: 0, right: 0)
        case .imageBottom:  // 图下字上
            imageEdgeInsets = UIEdgeInsets(top: labH + margin, left: 0, bottom: 0, right: -labW)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imgW, bottom: imgH + margin, right: 0)
        }
    }
}
