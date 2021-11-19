//
// UIFont-LDDExtensions.swift
// Created by HouWan
//
// swiftlint:disable identifier_name
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Foundation)
import Foundation
#endif

/// 输出iOS系统自带的所有字体:
///
/// 注意，familyNames 获取到的字体大全里不包含系统默认字体(iOS 13 是 .SFUI，iOS 12 及以前是 .SFUIText)
/// 输出的是`fontName`，直接使用即可: `UIFont(name: String, size: CGFloat)`
///
/// ```Swift
/// for familyName in UIFont.familyNames {
///     for fontName in UIFont.fontNames(forFamilyName: familyName) {
///         print("字体: ", fontName)
///     }
/// }
/// ```

// =============================================================================
// MARK: - Initialization
// =============================================================================
extension UIFont {

    /// 快捷创建一个**Medium System Font**，因为UI使用此字体频率非常高
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func medium(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
    }

    /// 快捷创建一个**Semibold System Font**，因为UI使用此字体频率非常高
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func semibold(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
    }

    /// 快捷创建一个**Regular System Font**，因为UI使用此字体频率非常高
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func regular(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
    }

    /// 快捷创建一个**Regular System Font**，因为UI使用此字体频率非常高
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func bold(ofSize fontSize: CGFloat) -> UIFont {
        UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
    }

    /// 快捷创建一个**DIN Alternate Bold**字体，因为UI使用此字体频率非常高
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func DINAlternateBold(ofSize fontSize: CGFloat) -> UIFont {
        // 字体的fontName是通过最上面的办法输出得到的
        UIFont(name: "DINAlternate-Bold", size: fontSize) ?? MediumFont(fontSize)
    }

}

// =============================================================================
// MARK: - Function
// =============================================================================

/// 快捷创建一个**Medium System Font**，因为UI使用此字体频率非常高
///
/// - Parameter fontSize: fontSize: 字体大小
/// - Returns: UIFont对象
public func MediumFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.medium(ofSize: fontSize)
}

/// 快捷创建一个**Semibold System Font**，因为UI使用此字体频率非常高
///
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func SemiboldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.semibold(ofSize: fontSize)
}

/// 快捷创建一个**System Font**，因为UI使用此字体频率非常高
///
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func SystemFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

/// 快捷创建一个**Regular System Font**，因为UI使用此字体频率非常高
///
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func RegularFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.regular(ofSize: fontSize)
}

/// 快捷创建一个**Bold System Font**，因为UI使用此字体频率非常高
///
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func BoldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.bold(ofSize: fontSize)
}

/// 快捷创建一个**DIN Alternate Bold**字体，因为UI在很多数字使用此字体，此字体是iOS自带字体
///
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func DINAlternateBold(_ fontSize: CGFloat) -> UIFont {
    // 字体的fontName是通过最上面的办法输出得到的
    return UIFont(name: "DINAlternate-Bold", size: fontSize) ?? MediumFont(fontSize)
}
