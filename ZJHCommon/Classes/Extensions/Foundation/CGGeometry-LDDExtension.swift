//
//  CGGeometry-LDDExtension.swift
//  Created by HouWan
//

import Foundation
import CoreGraphics
import Darwin

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
private func fixPixelScale(floatValue: CGFloat, scale: CGFloat) -> CGFloat {
    if floatValue.isNaN || floatValue.isZero || floatValue.isInfinite { return 0 }

    let newScale = Float(scale <= 0 ? UIScreen.main.scale : scale)
    return CGFloat(ceilf(Float(floatValue) * newScale) / newScale)
}

// =============================================================================
// MARK: - Darwin
// =============================================================================

public extension CGFloat {
    /// 向下取整 :  3.2 -> 3   3.7 -> 3
    var floor: CGFloat { CGFloat(floorf(Float(self))) }

    /// 向上取整 :  3.2 -> 4   3.7 -> 4
    var ceil: CGFloat { CGFloat(ceilf(Float(self))) }

    /// 四舍五入 :  3.2 -> 3   3.7 -> 4
    var round: CGFloat { CGFloat(roundf(Float(self))) }

    /// 根据当前设备的屏幕倍数进行像素对齐
    var align: CGFloat { fixPixelScale(floatValue: self, scale: 0) }

    /// Change to `Float`.
    var float: Float { Float(self) }

    /// Change to `Int`.
    var int: Int { Int(self) }

    /// Change to `Double`.
    var double: Double { Double(self) }

    /// 绝对值
    var abs: CGFloat { CGFloat(fabsf(Float(self))) }
}

public extension CGSize {
    /// 根据`CGSize`返回一个`x = 0`和`y = 0`的`CGRect`
    var rect: CGRect { CGRect(origin: .zero, size: self) }

    /// 判断一个`CGSize`是否为空（宽或高为0）
    var isEmpty: Bool { width <= 0 || height <= 0 }

    /// 判断一个`CGSize`是否存在 infinite 无限的
    var isInfinite: Bool { width.isInfinite || height.isInfinite }

    /// 判断一个`CGSize`是否存在 NaN 值（宽或高为NaN）
    var isNaN: Bool { width.isNaN || height.isNaN }

    /// 向下取整 :  CGSize(3.2, 3.7) -> CGSize(3.0, 3.0)
    var floor: CGSize { CGSize(width: width.floor, height: height.floor) }

    /// 向上取整 :  CGSize(3.2, 3.7) -> CGSize(4.0, 4.0)
    var ceil: CGSize { CGSize(width: width.ceil, height: height.ceil) }

    /// 四舍五入 :  CGSize(3.2, 3.7) -> CGSize(3.0, 4.0)
    var round: CGSize { CGSize(width: width.round, height: height.round) }

    /// 根据当前设备的屏幕倍数进行像素对齐
    var align: CGSize { CGSize(width: width.align, height: height.align) }

    /// set|get to `width`
    var w: CGFloat {
        get { width }
        set { self = CGSize(width: newValue, height: height) }
    }

    /// set|get to `height`
    var h: CGFloat {
        get { height }
        set { self = CGSize(width: width, height: newValue) }
    }

    /// 初始化，跟OC的用法一样
    init(_ w: CGFloat, _ h: CGFloat) {
        self.init(width: w, height: h)
    }

    /// 根据`CGPoint`和当前的`CGSize`组合成一个`CGRect`
    func rect(_ point: CGPoint) -> CGRect {
        CGRect(origin: point, size: self)
    }
}

public extension CGPoint {
    /// 根据`CGPoint`返回一个`w = 0`和`h = 0`的`CGRect`
    var rect: CGRect { CGRect(origin: self, size: .zero) }

    /// 判断一个`CGPoint`是否为原点（x,y为0）
    var isOrigin: Bool { x == 0 && y == 0 }

    /// 判断一个`CGPoint`是否存在 infinite 无限的
    var isInfinite: Bool { x.isInfinite || y.isInfinite }

    /// 判断一个`CGPoint`是否存在 NaN 值（x或y为NaN）
    var isNaN: Bool { x.isNaN || y.isNaN }

    /// 向下取整 :  CGPoint(3.2, 3.7) -> CGPoint(3.0, 3.0)
    var floor: CGPoint { CGPoint(x: x.floor, y: y.floor) }

    /// 向上取整 :  CGPoint(3.2, 3.7) -> CGPoint(4.0, 4.0)
    var ceil: CGPoint { CGPoint(x: x.ceil, y: y.ceil) }

    /// 四舍五入 :  CGPoint(3.2, 3.7) -> CGPoint(3.0, 4.0)
    var round: CGPoint { CGPoint(x: x.round, y: y.round) }

    /// 根据当前设备的屏幕倍数进行像素对齐
    var align: CGPoint { CGPoint(x: x.align, y: y.align) }

    /// 初始化，跟OC的用法一样 (故意区别于自带的x/y)
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }

    /// 根据`CGPoint`和当前的`CGSize`组合成一个`CGRect`
    func rect(_ size: CGSize) -> CGRect {
        CGRect(origin: self, size: size)
    }
}

public extension CGRect {
    /// set|get to `x`
    var x: CGFloat {
        get { origin.x }
        set { self = CGRect(x: newValue, y: y, width: width, height: height) }
    }

    /// set|get to `y`
    var y: CGFloat {
        get { origin.y }
        set { self = CGRect(x: x, y: newValue, width: width, height: height) }
    }

    /// set|get to `width`
    var w: CGFloat {
        get { width }
        set { self = CGRect(x: x, y: y, width: newValue, height: height) }
    }

    /// set|get to `height`
    var h: CGFloat {
        get { height }
        set { self = CGRect(x: x, y: y, width: width, height: newValue) }
    }

    /// 返回center
    var center: CGPoint { CGPoint(x: midX, y: midY) }

    /// 向下取整 :  3.2 -> 3   3.7 -> 3
    var floor: CGRect { CGRect(origin: origin.floor, size: size.floor) }

    /// 向上取整 :  3.2 -> 4   3.7 -> 4
    var ceil: CGRect { CGRect(origin: origin.ceil, size: size.ceil) }

    /// 四舍五入 :  3.2 -> 3   3.7 -> 4
    var round: CGRect { CGRect(origin: origin.round, size: size.round) }

    /// 向下取整 :  3.2 -> 3   3.7 -> 3
    var floorSize: CGRect { CGRect(origin: origin, size: size.floor) }

    /// 向上取整 :  3.2 -> 4   3.7 -> 4
    var ceilSize: CGRect { CGRect(origin: origin, size: size.ceil) }

    /// 四舍五入 :  3.2 -> 3   3.7 -> 4
    var roundSize: CGRect { CGRect(origin: origin, size: size.round) }

    /// 根据当前设备的屏幕倍数进行像素对齐
    var align: CGRect { CGRect(origin: origin.align, size: size.align) }

    /// 根据当前设备的屏幕倍数进行像素对齐
    var alignSize: CGRect { CGRect(origin: origin, size: size.align) }

    /// 初始化，跟OC的用法一样
    init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}

extension UIEdgeInsets {
    /// 初始化，跟OC的用法一样
    init(_ t: CGFloat, _ l: CGFloat, _ b: CGFloat, _ r: CGFloat) {
        self.init(top: t, left: l, bottom: b, right: r)
    }
}

///
/// 获得指定类型的最大值，`infinity`无限的
/// ```swift
/// // 注意: `infinity`不能参与任何运算，因为要么返回`infinity`，要么返回`NaN`
/// let x = Float.infinity  // inf
/// ```
///
/// ----
///
/// `addProduct(x, y)`将x和y相乘，再加上调用者，同理`addingProduct(x, y)`
/// ```swift
/// var a = 1.5
/// a.addProduct(2, 0)
/// print(a)  // 1.5  因为 2 * 0 + 1.5
///
/// var b: Float = 1.0
/// b.addProduct(2.0, 4.0)
/// print(b)  // 9.0  因为 2 * 4 + 1
/// ```
///
/// `advanced(by: x)`将调用者加上x返回
/// ```swift
/// var a = 1.5
/// let x = a.advanced(by: 1.1)
/// print(x)  // 2.6  因为 1.5 + 1.1 = 2.6
/// ```
///
/// `distance(to: x)`将x减去调用者返回
/// ```swift
/// var a = 1.5
/// let x = a.distance(to: 1.2)
/// print(x)  // -0.3  因为 1.2 - 1.5 = -0.3
///
/// var b: Float = 3
/// let y = b.distance(to: 5)
/// print(y)  // 2.0  因为 5 - 3 = 2
/// ```
///
/// `isLess(than: x)` 调用者是否小于x
/// ```swift
/// var a = 1.5123
/// var b = 10.0
/// a.isLess(than: 6)  // true
/// b.isLess(than: 6)  // false
/// ```
///
/// `isLessThanOrEqualTo(x)` 调用者是否小于等于x
/// ```swift
/// var a = 6.0
/// var b = 9.0
/// a.isLessThanOrEqualTo(6.0)  // true
/// b.isLessThanOrEqualTo(6.0)  // false
/// ```
///
/// `x.negate()`获取x的反数，就是正数变负数，负数变正数
/// ```swift
/// var a = 6.123
/// var b = -10.0
/// a.negate()  // -6.123
/// b.negate()  // 10.0
/// ```
///
/// `x.round(.type)`将浮点数值转换为整型数值，类型很多，官方文档也解释很详细，很有用。
/// ```swift
/// var a = 6.123
/// a.round(.down)  // 6.0
/// var b = 6.123
/// b.round(.up)  // 7.0
///
/// /**
/// .down 浮点转为整型，并舍入到小于或等于源数值的最接近的允许值
/// .up  浮点转为整型，并舍入到大于或等于源数值的最接近的允许值
/// .awayFromZero 浮点转为整型，并舍入到幅度大于或等于源数值的允许值，即向远离0的方向舍入
/// .towardZero 浮点转为整型，并舍入到幅度小于或等于源数值的允许值，即向靠近0的方向舍入
/// .toNearestOrAwayFromZero 并舍入到最接近的允许值，如果两个值同样接近，则选择具有较大幅度的值
/// */
/// ```
///
/// ----
///
/// `x.significand` 猜的: 内存存储底数，基本用不到，估计跟计算机底层有关系，苹果文档也有详细描述
/// ```swift
/// var a = 1.5123
/// print(a.significand)  // 1.5123
///
/// var b: Float = 10.1
/// print(b.significand)  // 1.2625
/// ```
///
/// `x.exponent`猜的:跟计算机内存存储有关系，指数，跟`x.significand`一起用
/// ```swift
/// var a = 1.5123
/// print(a.exponent)  // 0
///
/// var b: Float = 10
/// print(b.exponent)  // 3
/// ```
///
/// `x.description` 转为字符串
/// ```swift
/// var a = 1.5123  // 1.5123
/// var b: Float = 10  // 10.0
/// var c = 1.01  // 1.01
/// print(c.description)
/// ```
///
/// `x.isFinite` 是否是有限的，注意:`NaN`也是`true`
/// ```swift
/// var a = 1.5123
/// var b = Double.nan
/// var c = Double.infinity
///
/// a.isFinite  // true
/// a.isFinite  // true
/// c.isFinite  // false
/// ```
///
/// `x.isInfinite` 是否是无限的，注意:`NaN`也是`false`
/// ```swift
/// var a = 1.5123
/// var b = Double.nan
/// var c = Double.infinity
///
/// a.isInfinite  // false
/// b.isInfinite  // false
/// c.isInfinite  // true
/// ```
///
/// `x.isNaN`数字x是否是异常数
/// ```swift
/// var a = 6.0
/// var b = Double.nan
/// a.isNaN  // false
/// b.isNaN  // true
/// ```
///
/// `x.isZero`是否是0
/// ```swift
/// var a = 6.0
/// var b = 0.0
/// a.isZero  // false
/// b.isZero  // true
/// ```
///
/// `x.magnitude`得到x的绝对值，但是官方说，绝对值用函数`abs(_:)`更好，很奇怪
/// ```swift
/// var a = 6.123
/// var b = -10.0
/// a.magnitude  // 6.123
/// b.magnitude  // 10.0
/// ```
