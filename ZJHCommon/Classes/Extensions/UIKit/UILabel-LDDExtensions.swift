//
//  UILabel-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
import Foundation
#endif

// =============================================================================
// MARK: - Initialization
// =============================================================================
extension UILabel {
    /// 快速创建一个`UILabel`，使用`font & textColor | alignment`
    ///
    /// - Author: HouWan
    ///
    /// - Parameters:
    ///   - font: UIFont对象
    ///   - color: 字体颜色
    ///   - alignment: The default was NSTextAlignmentLeft
    convenience public init(font: UIFont, color: UIColor, align: NSTextAlignment = .left) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = align
    }

    func attributeWithColor(_ str:String,_ color:UIColor,_ font:UIFont) {
        guard ((self.text?.contains(str)) != nil) else {return}
        let attributes = NSMutableAttributedString(string: self.text!)
        let range = self.text?.nsRange(subString: str)
        attributes.setAttributes([NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.font:font], range: range!)
        self.attributedText = attributes
    }
}
