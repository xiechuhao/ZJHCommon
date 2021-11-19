//
//  UIScrollView-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
import Foundation
#endif

// =============================================================================
// MARK: - Empty
// =============================================================================
extension UIScrollView {
    fileprivate static var LDD_EMPTYCONTENT_KEY: Void?
    fileprivate static var LDD_EMPTYICON_KEY: Void?
    fileprivate static var LDD_EMPTYLABEL_KEY: Void?

    /// 空状态的`ContentView`
    fileprivate var empty_content_view: UIView? {
        get {
            objc_getAssociatedObject(self, &(UIScrollView.LDD_EMPTYCONTENT_KEY)) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &(UIScrollView.LDD_EMPTYCONTENT_KEY), newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 空状态的`UIImageView`
    fileprivate var empty_icon_view: UIImageView? {
        get {
            objc_getAssociatedObject(self, &(UIScrollView.LDD_EMPTYICON_KEY)) as? UIImageView
        }
        set {
            objc_setAssociatedObject(self, &(UIScrollView.LDD_EMPTYICON_KEY), newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 空状态的`UILabel`
    fileprivate var empty_message_label: UILabel? {
        get {
            objc_getAssociatedObject(self, &(UIScrollView.LDD_EMPTYLABEL_KEY)) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &(UIScrollView.LDD_EMPTYLABEL_KEY), newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 创建一个空状态显示
    ///
    /// - Author: HouWan
    ///
    /// - Parameters:
    ///   - message: 空状态显示的文本信息，可以为nil
    ///   - image: 空状态显示的icon，可以为nil
    ///   - top: 自定义空状态整体的Y值，默认是居中
    func empty_show(_ message: String?, _ image: UIImage?, top: CGFloat? = nil) {
        if message == nil && image == nil {
            empty_remove()
            return
        }

        if frame.height <= 0 || frame.width <= 0 {
            return
        }

        // 1.
        var empty_contentView = self.empty_content_view
        empty_contentView?.isHidden = false
        if empty_contentView == nil {
            empty_contentView = UIView()
            empty_contentView!.clipsToBounds = true
            addSubview(empty_contentView!)
            self.empty_content_view = empty_contentView
        }

        // 2.
        var y: CGFloat = 0, x: CGFloat = 0, w: CGFloat = 0, h: CGFloat = 0
        if let img = image {
            w = img.size.width
            h = img.size.height
            x = (self.width - w) * 0.5

            if x < 0 {
                x = 15.0
                w = self.width - x * 2.0
                h = (w / img.size.width) * img.size.height
            }

            var empty_imgView = self.empty_icon_view
            if empty_imgView == nil {
                empty_imgView = UIImageView()
                empty_contentView!.addSubview(empty_imgView!)
                self.empty_icon_view = empty_imgView
            }
            empty_imgView?.image = img
            empty_imgView?.isHidden = false
            empty_imgView?.frame = CGRect(x: x, y: y, width: w, height: h)
            y = empty_imgView!.maxY + 20.0
        } else {
            self.empty_icon_view?.image = nil
            self.empty_icon_view?.isHidden = true
        }

        // 3.
        if let msg = message {
            var empty_infoLabel = self.empty_message_label
            if empty_infoLabel == nil {
                empty_infoLabel = UILabel(font: UIFont.systemFont(ofSize: 15), color: UIColor(0x808080), align: .center)
                empty_infoLabel?.numberOfLines = 0
                empty_contentView?.addSubview(empty_infoLabel!)
                self.empty_message_label = empty_infoLabel
            }

            empty_infoLabel?.text = msg
            empty_infoLabel?.isHidden = false

            x = 20
            w = self.width - x * 2.0
            h = msg.ldd_heightForFont(empty_infoLabel?.font, width: w) + 2  // 防止有emoji表情
            empty_infoLabel?.frame = CGRect(x: x, y: y, width: w, height: h)
            y = empty_infoLabel!.maxY
        } else {
            self.empty_message_label?.text = nil
            self.empty_message_label?.isHidden = true
        }

        // 4.
        h = y
        y = top ?? (self.height - h) * 0.5
        empty_contentView?.frame = CGRect(x: 0, y: y, width: self.width, height: h)
    }

    /// 隐藏空状态，对于是**hidden**还是**remove**，根据页面情况自行决定即可，其实大部分情况下，都可以。
    func empty_hidden() {
        self.empty_content_view?.isHidden = true
    }

    /// 移除空状态，对于是**hidden**还是**remove**，根据页面情况自行决定即可，其实大部分情况下，都可以。
    func empty_remove() {
        self.empty_content_view?.ldd_removeAllSubviews()
        self.empty_content_view?.removeFromSuperview()
        self.empty_icon_view = nil
        self.empty_message_label = nil
        self.empty_content_view = nil
    }
}
