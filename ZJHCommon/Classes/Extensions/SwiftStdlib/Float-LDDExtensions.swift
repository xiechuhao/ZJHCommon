//
//  Float-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if canImport(UIKit)
import UIKit
#endif

// =============================================================================
// MARK: - Properties
// =============================================================================

public extension Float {

    /// 向下取整 :  3.2 -> 3   3.7 -> 3
    var floor: Float { floorf(self) }

    /// 向上取整 :  3.2 -> 4   3.7 -> 4
    var ceil: Float { ceilf(self) }

    /// 四舍五入 :  3.2 -> 3   3.7 -> 4
    var round: Float { roundf(self) }

    /// Change to Int.
    var int: Int { return Int(self) }

    /// Change to Double.
    var double: Double { return Double(self) }

    /// 绝对值
    var abs: Float { fabsf(self) }

    #if canImport(CoreGraphics)
    /// Change to CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    #endif

    /// 字符串形式，eg: 12.010 -> 12.01.  12.0 -> 12， 详情见下面的文档
    var string: String {
        NSNumber(value: self).stringValue
    }

    #if canImport(UIKit)
    /// 根据当前设备的屏幕倍数进行像素对齐
    var align: Float { fixPixelScale(floatValue: self, scale: 0) }
    #endif
}

// =============================================================================
// MARK: - Methods
// =============================================================================

#if canImport(UIKit)
public extension Float {
    /// 将number转为字符串，并指定小数位数，注意，默认不会自动补0
    ///
    ///     let a: Float = 20
    ///     let b: Float = 20.01
    ///     let c: Float = 20.12345678
    ///     let d: Float = 20.98765432
    ///     a.format(2, autoZero: true)  // true: "20.00" | false: "20"
    ///     b.format(2, autoZero: true)  // true: "20.01" | false: "20.01"
    ///     c.format(2, autoZero: true)  // true: "20.12" | false: "20.12"
    ///     d.format(2, autoZero: true)  // true: "20.99" | false: "20.99"
    ///
    /// - note: 此方法会四舍五入 6.77777 --> 6.78
    ///
    /// - Parameters:
    ///   - scale: 小数位数
    ///   - autoZero: 是否自动补0，`true`自动补0，`false`不会补0，eg: `21.0`,`21`
    func format(_ scale: UInt8, autoZero: Bool = false) -> String {
        let fa = NumberFormatter()
        fa.maximumFractionDigits = Int(scale)
        fa.minimumFractionDigits = Int(scale)
        fa.numberStyle = .decimal

        fa.decimalSeparator = "."
        fa.usesGroupingSeparator = false  // 不用组分割
        fa.groupingSeparator = ""  // 分割符号
        fa.groupingSize = 10  //分割位数

        if !autoZero {
            var s = "#"
            if scale > 0 {
                s += "."
                for _ in 0..<scale { s += "#" }
                fa.positiveFormat = s
            }
        }

        return fa.string(from: NSNumber(value: self)) ?? ""
    }
}
#endif

// =============================================================================
// MARK: - Function
// =============================================================================

/// 基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准\n
/// 这个跟`ceil`的区别是在不同的屏幕Scale下，得到的结果是不一样的。
///
///             @2x     @3x
///     4.1 --> 4.5 --> 4.333
///     4.5 --> 4.5 --> 4.666
///     4.7 --> 5.0 --> 5.0
///     5.0 --> 5.0 --> 5.0
///
/// - Parameters:
///   - floatValue: 要像素对齐的数值
///   - scale: 倍率, eg. “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）
private func fixPixelScale(floatValue: Float, scale: CGFloat) -> Float {
    if floatValue.isNaN || floatValue.isZero || floatValue.isInfinite { return 0 }
    if floatValue == Float.leastNormalMagnitude { return 0 }  // leastNormalMagnitude 最大取值
    if floatValue == Float.greatestFiniteMagnitude { return 0 }  // greatestFiniteMagnitude 最小取值

    let newScale = Float(scale <= 0 ? UIScreen.main.scale : scale)
    return ceilf(floatValue * newScale) / newScale
}

///
/// 直接字符串差值，结果如下: `"\(x)"`
/// ```
/// let a: Float = 12.0       -> 12.0
/// let b: Float = 12.010     -> 12.01
/// let c: Float = 12.020100  -> 12.0201
/// let d: Float = 12         -> 12.0
/// let e: Float = 12.0289    -> 12.0289
/// ```
///
/// 使用`NSNumber.stringValue`的结果如下:
/// ```
/// let a: Float = 12.0       -> 12
/// let b: Float = 12.010     -> 12.01
/// let c: Float = 12.020100  -> 12.0201
/// let d: Float = 12         -> 12
/// let e: Float = 12.0289    -> 12.0289
/// ```
///
/// 使用`NumberFormatter`进行格式化的结果:(*保留两位小数*)
/// ```
/// let a: Float = 12.0       -> 12.00
/// let b: Float = 12.010     -> 12.01
/// let c: Float = 12.020100  -> 12.02
/// let d: Float = 12         -> 12.00
/// let e: Float = 12.0289    -> 12.03
/// ```
///
/// 使用`NSDecimalNumber`进行模拟计算的结果:(*保留两位小数*)
/// ```
/// let a: Float = 12.0       -> 12
/// let b: Float = 12.010     -> 12.01
/// let c: Float = 12.020100  -> 12.02
/// let d: Float = 12         -> 12
/// let e: Float = 12.0289    -> 12.03
/// ```
///
