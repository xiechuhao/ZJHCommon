//
//  String-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(UIKit)
import UIKit
#endif

import CommonCrypto

// MARK: - Properties
public extension String {

    /// 是否是有效的字符串（当是nil、@""、空格、\n、null、<null>等，返回NO）
    var isValid: Bool {
        guard !self.isEmpty else { return false }
        guard self != "null" else { return false }
        guard self != "nil" else { return false }
        guard self != "<null>" else { return false }

        var t = self.trimmingCharacters(in: .whitespacesAndNewlines)
        t = t.replacingOccurrences(of: " ", with: "")
        t = t.replacingOccurrences(of: "\r", with: "")
        t = t.replacingOccurrences(of: "\n", with: "")
        guard !t.isEmpty else { return false }
        return true
    }

    /// 是否是有效的字符串（当是nil、@""、空格、\n等，返回NO）
    var isChecked: Bool {
        guard !self.isEmpty else { return false }
        let temp = trimmedAll
        guard !temp.isEmpty else { return false }
        return true
    }

    /// 移除字符串首尾空格和换行符
    /// Trim blank characters (space and newline) in head and tail.
    var trimmed: String {
        guard !isEmpty else { return "" }
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 移除String所有的空格和换行符(space and newline)
    var trimmedAll: String {
        guard !isEmpty else { return "" }
        var t = self.trimmingCharacters(in: .whitespacesAndNewlines)
        t = t.replacingOccurrences(of: " ", with: "")
        t = t.replacingOccurrences(of: "\r", with: "")
        t = t.replacingOccurrences(of: "\n", with: "")
        return t
    }

    /// Returns `NSMakeRange(0, self.length)`
    /// ⚠️⚠️⚠️`count`属性是指字符串肉眼可见的字符个数，比如 "😝A" -> count = 2，这点跟`NSString.length`是不一样的
    /// 但是在格式化字符串时，比如富文本，它的长度并不是2，而是3
    var nsRange: NSRange { NSRange(..<endIndex, in: self) }

    /// 返回`NSString.length`，和`count`的区别是:
    /// "😝A" -> count = 2,   length = 3
    var length: NSInteger { utf16.count }

    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// 将`String`转为URL，如果能转成功的话
    var url: URL? {
        // 编码：addingPercentEncoding & urlQueryAllowed
        // 解码：url.removingPercentEncoding
        guard let t = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: t)
    }

    #if canImport(Foundation)
    /// 正则表达式 Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func ldd_matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif
}

// MARK: - Drawing
public extension String {

    /// Returns the size of the string if it were rendered with the specified constraints.
    ///
    /// - SeeAlso: https://www.jianshu.com/p/8b8d208b0a26
    ///
    /// - Parameters:
    ///   - font: The font to use for computing the string width.
    ///   - size: The maximum acceptable size for the string. This value is
    ///           used to calculate where line breaks and wrapping would occur.
    ///   - lineBreakMode: The line break options for computing the size of the string.
    ///                    For a list of possible values, see NSLineBreakMode.
    ///
    /// - Returns: The width and height of the resulting string's bounding box.
    ///            These values may be rounded up to the nearest whole number.
    func ldd_sizeForFont(_ font: UIFont?, size: CGSize, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        guard !isEmpty else { return CGSize.zero }
        let f = font ?? UIFont.systemFont(ofSize: 12)

        var attributes: [NSAttributedString.Key: Any] = [.font: f]
        if lineBreakMode != .byWordWrapping {
            let ps = NSMutableParagraphStyle()
            ps.lineBreakMode = lineBreakMode
            attributes[.paragraphStyle] = ps
        }

        let rect = (self as NSString).boundingRect(with: size,
                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                   attributes: attributes, context: nil)
        return rect.size
    }

    /// Returns the size of the string if it were rendered with the specified constraints.
    func ldd_sizeForFont(_ font: UIFont?) -> CGSize {
        ldd_sizeForFont(font, size: CGSize(width: 100000, height: 100000))
    }

    /// Returns the width of the string if it were to be rendered with the specified font on a single line.
    ///
    /// - Parameters:
    ///   - font: The font to use for computing the string width.
    ///
    /// - Returns: The width of the resulting string's bounding box. These values may be
    ///            rounded up to the nearest whole number.
    func ldd_widthForFont(_ font: UIFont?) -> CGFloat {
        if self.isEmpty { return 0 }

        let size = self.ldd_sizeForFont(font, size: CGSize(width: 100000, height: 100000))
        return CGFloat(ceilf(Float(size.width)))
    }

    /// Returns the height of the string if it were rendered with the specified constraints.
    ///
    /// - Parameters:
    ///   - font: The font to use for computing the string size.
    ///   - width: The maximum acceptable width for the string. This value is used
    ///             to calculate where line breaks and wrapping would occur.
    ///
    /// - Returns: The height of the resulting string's bounding box. These values
    ///            may be rounded up to the nearest whole number.
    func ldd_heightForFont(_ font: UIFont?, width: CGFloat = 10000) -> CGFloat {
        if self.utf16.count < 15 {
            return CGFloat(ceilf(Float(font?.lineHeight ?? 0)))
        }

        let size = self.ldd_sizeForFont(font, size: CGSize(width: width, height: CGFloat(HUGE)))
        return CGFloat(ceilf(Float(size.height)))
    }

    /// ⚠️Returns the height of the string if it were rendered with the specified constraints.
    ///
    /// ⚠️跟上面的区别在于：上面的方法会判断`15`个字，如果低于15个字，就直接返回字体高度，本方法不会
    ///
    /// - Parameters:
    ///   - font: The font to use for computing the string size.
    ///   - width: The maximum acceptable width for the string. This value is used
    ///             to calculate where line breaks and wrapping would occur.
    ///
    /// - Returns: The height of the resulting string's bounding box. These values
    ///            may be rounded up to the nearest whole number.
    func ldd_heightWith(_ font: UIFont?, width: CGFloat = 10000) -> CGFloat {
        let size = self.ldd_sizeForFont(font, size: CGSize(width: width, height: CGFloat(HUGE)))
        return CGFloat(ceilf(Float(size.height)))
    }
}

// MARK: - InstanceMethods
public extension String {

    /// 根据`subString`获得它的`NSRange`，如果`subString`为nil或`length=0`，则返回`NSRange(0, 0)`
    ///
    ///     var str = "么么哒123😝abcd123"
    ///     str.range(subString: "123")  // {3, 3}
    ///     str.range(subString: "abcd")  // {8, 4}
    ///     str.range(subString: "😝")  // {6, 2}
    ///     str.range(subString: "xyz")  // {0, 0}
    ///
    /// - Parameter subString: 要匹配的字符串
    ///
    /// - Note: 没有匹配返回`NSRange(0, 0)`，由于String有`range`方法了，这里就叫`nsRange`了
    func nsRange<T: StringProtocol>(subString str: T?) -> NSRange {
        if let s = str, let r = range(of: s) {
            return NSRange(r, in: self)
        }
        return NSRange(location: 0, length: 0)
    }

    /// 截取指定范围字符串，并且它是安全的
    func safeRange<T>(safe range: T) -> String? where T: RangeExpression, T.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
            let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
                return nil
        }

        return String(self[lowerIndex..<upperIndex])
    }
}

extension String {

    /// 不需要毫秒的时间戳
    var interval: String {
        if self.count > 10 {
            return String(self.prefix(self.count - 3))
        } else {
            return self
        }
    }

    /// 时间戳转字符串格式
    /// - Parameter dateFormatter: 格式
    /// - Returns: 字符串
    func toDateString(_ dateFormatter: String = "yyyy.MM.dd") -> String {
        guard !self.isEmpty else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        let date = Date(timeIntervalSince1970: TimeInterval(interval) ?? 0)
        let result = formatter.string(from: date)
        return result
    }

    /// 时间戳转date
    /// - Returns: Date
    func toDate() -> Date {
        guard !self.isEmpty else {
            return Date()
        }
        let date = Date(timeIntervalSince1970: TimeInterval(interval) ?? 0)
        return date
    }

    /// 时间戳转北京date
    /// - Returns: Date
    func toBeijingDate() -> Date {
        guard !self.isEmpty else {
            return Date()
        }
        if let time = TimeInterval(interval) {
            return Date(timeIntervalSince1970: time + TimeInterval(8 * 60 * 60))
        } else {
            return Date(timeIntervalSinceNow: TimeInterval(8 * 60 * 60))
        }
    }

    /// 时间戳转时间格式 example: 今天 10:00, 昨天 11:00
    /// - Returns: 字符串
    func toTimeChangeNow() -> String {
        guard !self.isEmpty else {
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

    /// 时间字符串转时间戳
    /// - Parameter dateFormatter: 时间格式
    /// - Returns: 时间戳
    func toTimestampFromString(_ dateFormatter: String = "yyyy-MM-dd HH:mm") -> String {
        guard !self.isEmpty else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter

        let dateTodo = formatter.date(from: self)
        let timeSp = "\(Int(dateTodo?.timeIntervalSince1970 ?? 0))"
        return timeSp
    }

    enum MD5EncryptType {
        /// 32位小写
        case lowercase32
        /// 32位大写
        case uppercase32
        /// 16位小写
        case lowercase16
        /// 16位大写
        case uppercase16
    }

    /// MD5加密 默认是32位小写加密
    /// - Parameter type: 加密类型
    /// - Returns: 加密字符串
    func DDMD5Encrypt(_ md5Type: MD5EncryptType = .lowercase32) -> String {
        guard !isEmpty else {
            print("⚠️⚠️⚠️md5加密无效的字符串⚠️⚠️⚠️")
            return ""
        }
        /// 1.把待加密的字符串转成char类型数据 因为MD5加密是C语言加密
        let cCharArray = self.cString(using: .utf8)
        /// 2.创建一个字符串数组接受MD5的值
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        /// 3.计算MD5的值
        /*
         第一个参数:要加密的字符串
         第二个参数: 获取要加密字符串的长度
         第三个参数: 接收结果的数组
         */
        CC_MD5(cCharArray, CC_LONG(cCharArray!.count - 1), &uint8Array)

        switch md5Type {
            /// 32位小写
        case .lowercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
            /// 32位大写
        case .uppercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
            /// 16位小写
        case .lowercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
            return tempStr.safeRange(safe: 8..<24)!
            /// 16位大写
        case .uppercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
            return tempStr.safeRange(safe: 8..<24)!
        }
    }
}
