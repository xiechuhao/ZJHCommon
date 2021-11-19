//
//  Int-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - Properties
public extension Int {

    /// Change to Double.
    var double: Double {
        return Double(self)
    }

    /// Change to Float.
    var float: Float {
        return Float(self)
    }

    /// 绝对值
    var abs: Int { Swift.abs(self) }

    #if canImport(CoreGraphics)
    /// Change to CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    #endif
}

// MARK: - Methods
public extension Int {

    /// 重复执行`task`闭包N次,
    /// - Parameter task: 要重复执行的闭包
    func `repeat`(task: (_ index: Int) -> Void) {
        guard self > 0 else { return }
        for i in 0..<self { task(i) }
    }
}

/// 时间单位
enum IntTimeUnit {
    case seconds, minutes, hours
}

extension Int {

    var interval: String {
        if String(self).count > 10 {
            return String(String(self).prefix(String(self).count - 3))
        } else {
            return String(self)
        }
    }

    /// 10位时间戳
    /// - Returns: 时间戳
    func toTimestamp() -> Int {
        return Int(interval) ?? self
    }

    /// 时间戳转字符串格式
    /// - Parameter dateFormatter: 格式
    /// - Returns: 字符串
    func toDateString(_ dateFormatter: String = "yyyy.MM.dd") -> String {
        guard self != 0 else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        let date = Date(timeIntervalSince1970: TimeInterval(interval) ?? 0)
        let result = formatter.string(from: date)
        return result
    }

    /// 时间格式 example: 今天 10:00, 昨天 11:00
    /// - Returns: 字符串
    func toTimeChangeNow() -> String {
        if self == 0 {
            return ""
        }
        // 日期
        let lhsDate = Date().phDate
        let rhsDate = Date(timeIntervalSince1970: TimeInterval(interval) ?? 0).phDate

        // 年
        guard lhsDate.year == rhsDate.year else {
            return self.toDateString("yyyy.MM.dd HH:mm")
        }
        // 月
        guard lhsDate.month == rhsDate.month else {
            return self.toDateString("MM.dd HH:mm")
        }
        // 天
        if lhsDate.day == rhsDate.day {
            return "今天 \(self.toDateString("HH:mm"))"
        } else if lhsDate.day - 1 == rhsDate.day {
            return "昨天 \(self.toDateString("HH:mm"))"
        } else {
            return self.toDateString("yyyy.MM.dd HH:mm")
        }
    }

    /// int转时间格式化
    /// - Parameter dateformatter: 时间的格式
    /// - Returns: 时间字符串
    func toTimeFormatter(_ units: IntTimeUnit = .seconds, dateformatter: String = "HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateformatter
        var c = DateComponents()
        switch units {
        case .seconds:
            c.second = self
        case .minutes:
            c.minute = self
        default:
            c.hour = self
        }
        let d: Date = Calendar.current.date(from: c) ?? Date()
        let str = formatter.string(from: d)
        return str
    }

    // MARK: - Int保留多少位 默认为2
    func keepInt(_ digits:Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = digits
        return formatter.string(for: self)!
    }
}
