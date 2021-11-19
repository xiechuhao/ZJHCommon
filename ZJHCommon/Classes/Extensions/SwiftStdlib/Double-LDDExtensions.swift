//
//  Double-LDDExtensions.swift
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

// MARK: - Properties
public extension Double {

    #if canImport(CoreGraphics)
    /// 向下取整 :  3.2 -> 3   3.7 -> 3
    var floor: Double { Darwin.floor(self) }

    /// 向上取整 :  3.2 -> 4   3.7 -> 4
    var ceil: Double { Darwin.ceil(self) }

    /// 四舍五入 :  3.2 -> 3   3.7 -> 4
    var round: Double { Darwin.round(self) }

    /// Change to CGFloat.
    var cgFloat: CGFloat { return CGFloat(self) }

    /// 绝对值
    var abs: Double { fabs(self) }

    /// 向上取整，具体到第几位，其实这个方法目的是为了知道可以这么计算
    ///
    ///     let a = 10.12345678
    ///     let b = 10.6789123
    ///     print(a.ceilValue(bit: 2))  // 10.13
    ///     print(b.ceilValue(bit: 2))  // 10.68
    ///
    /// 如果精确控制到某一位，也可以这么做，比如精度控制为 4 位小数
    /// 1.算出 10的4次方，让小数点右移4位，就是让原始小数扩大
    /// 2.对结果取整/四舍五入/直接舍小数等之后，再除以 10的4次方 进行还原
    ///
    ///     let a = 66.82170796666666
    ///     let fact = Darwin.pow(10.0, 4.0)
    ///     let result = Double(Int(a * fact)) / fact
    ///     print(result)  // 66.82170
    ///
    /// - Parameter bit: 小数位数
    func ceilValue(bit: Int = 0) -> Double {
        var n = bit
        var s = 1.0
        while n > 0 {
            n -= 1
            s *= 10
        }
        return Darwin.ceil(self * s) / s
    }
    #endif

    /// Change to Int.
    var int: Int { return Int(self) }

    /// Change to Float.
    var float: Float { return Float(self) }

    /// 字符串形式，eg: 12.010 -> 12.01.  12.0 -> 12， 详情见下面的文档
    var string: String {
        NSNumber(value: self).stringValue
    }
}

// MARK: - Methods
public extension Double {
    /// 将number转为字符串，并指定小数位数，注意，默认不会自动补0
    ///
    ///     let a: Double = 20
    ///     let b: Double = 20.01
    ///     let c: Double = 20.12345678
    ///     let d: Double = 20.98765432
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

    /// 数字格式多位数以千分号，逗号分割
    func changeNumberFormat(_ scale: UInt8, _ autoZero: Bool = false) -> String {
        let str: String = format(scale, autoZero: autoZero)
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.00;"
        let number = NSNumber.init(value: Double(str)!)
        let numberStr = numberFormatter.string(from: number)
        return (numberStr ?? "")
    }
}

extension Double {

    /// 保留对应的小数位
    /// - Parameter n: 位数
    /// - Returns: float
    func toRound(_ n: Int = 1) -> Double {
        let divisor: String = pow(10, n).description
        let f: Double = Double(divisor) ?? 0
        return (self * f).rounded() / f
    }

    /// 四舍五入
    /// - Returns: int
    func toInt() -> Int {
        return Int(self.rounded())
    }
}

extension Double {
    // MARK: - 时间戳转换成Date
    func timestampWithDate() -> Date {
        let date = Date.init(timeIntervalSince1970: self)
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
}

///
/// 直接字符串差值，结果如下: `"\(x)"`
/// ```
/// let a: Double = 12.0       -> 12.0
/// let b: Double = 12.010     -> 12.01
/// let c: Double = 12.020100  -> 12.0201
/// let d: Double = 12         -> 12.0
/// let e: Double = 12.0289    -> 12.0289
/// ```
///
/// 使用`NSNumber.stringValue`的结果如下:
/// ```
/// let a: Double = 12.0       -> 12
/// let b: Double = 12.010     -> 12.01
/// let c: Double = 12.020100  -> 12.0201
/// let d: Double = 12         -> 12
/// let e: Double = 12.0289    -> 12.0289
/// ```
///
/// 使用`NumberFormatter`进行格式化的结果:(*保留两位小数*)
/// ```
/// let a: Double = 12.0       -> 12.00
/// let b: Double = 12.010     -> 12.01
/// let c: Double = 12.020100  -> 12.02
/// let d: Double = 12         -> 12.00
/// let e: Double = 12.0289    -> 12.03
/// ```
///
/// 使用`NSDecimalNumber`进行模拟计算的结果:(*保留两位小数*)
/// ```
/// let a: Double = 12.0       -> 12
/// let b: Double = 12.010     -> 12.01
/// let c: Double = 12.020100  -> 12.02
/// let d: Double = 12         -> 12
/// let e: Double = 12.0289    -> 12.03
/// ```
///
