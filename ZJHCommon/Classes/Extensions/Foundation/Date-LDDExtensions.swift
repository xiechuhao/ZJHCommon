//
//  Date-LDDExtensions.swift
//  Created by HouWan
//

#if canImport(Foundation)
import Foundation
#endif

// =============================================================================
// MARK: - Properties
// =============================================================================
public extension Date {

    /// 周一到周日的枚举 Raw Value从1到7
    ///
    ///     let w = Date.Week.monday
    ///     w.rawValue  =  1
    ///     w.string    =  一
    ///     "\(w)"      =  monday
    ///
    enum Week: Int {
        /// 周一到周日 -> Mon. Tue. Wed. Thu. Fri. Sat. Sun.
        case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

        /// 对应枚举的中文，比如 monday -> 一, tuesday -> 二, ... sunday -> 日
        /// 这里也许有多语言问题，比如英文的周一也许应该是`Monday`或者`Mon.`
        var string: String {
            switch self {
            case .monday: return "一"
            case .tuesday: return "二"
            case .wednesday: return "三"
            case .thursday: return "四"
            case .friday: return "五"
            case .saturday: return "六"
            case .sunday: return "日"
            }
        }
    }

    /// User’s current calendar. 鉴于有时发生时区设定不一样的情况，这里统一设置为中国东八区公历
    /// 当然，这统一设置`Calendar`也方便Date扩展统一修改`Calendar`. 而且全局使用同一个`Calendar`对象也能提高性能
    var calendar: Calendar {
        // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
        return self.calendar
    }

    /// 当前的北京时间
    /// - Important: 需要配合`LDDTool.calendar`和`LDDTool.dateformatter`计算才是正确的结果
    /// - Note: 需要配合`LDDTool.calendar`和`LDDTool.dateformatter`计算才是正确的结果
    static var BeiJingDate: Date {
        Date.init()
    }

    /// Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }

    /// Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }

    /// Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }

    /// Weekday. 1, 2, 3...7
    ///
    ///     Date().weekday -> 5 // fifth day in the current week.
    ///
    var weekday: Week {
        var w = calendar.component(.weekday, from: self) - 1
        if w <= 0 { w = 7 }
        return Week(rawValue: w)!
    }

    /// Weekday. 一, 二, 三...日
    ///
    ///     Date().weekdayString -> 五 // fifth day in the current week.
    ///
    var weekdayString: String { weekday.string }

    /// Check if date is within today.
    ///
    ///     Date().isToday -> true
    ///
    var isToday: Bool {
        return calendar.isDateInToday(self)
    }

    /// Check if date is within yesterday.
    ///
    ///     Date().isYesterday -> false
    ///
    var isYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }

    /// Yesterday date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    var yesterday: Date {
        return self.addingTimeInterval(-24 * 60 * 60)
    }

    /// Tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    var tomorrow: Date {
        return self.addingTimeInterval(24 * 60 * 60)
    }
}

// =============================================================================
// MARK: - InstanceMethods
// =============================================================================
public extension Date {
    // MARK: Date modify

    /// Date by adding multiples of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }

    /// Date string from date.
    ///
    ///     Date().string("yyyy/MM/dd") -> "2020/09/10"
    ///     Date().string("HH:mm") -> "23:50"
    ///     Date().string("yyyy-MM-dd HH:mm") -> "2020-11-12 14:00"
    ///
    /// - Parameter format: Date format (default is "yyyy-MM-dd HH:mm:ss").
    /// - Returns: date string.
    /// - Note: 使用的是东八区公历`LDDTool.dateformatter`
    func string(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let df = Date.dateformatter
        df.dateFormat = format
        return df.string(from: self)
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp: String {
        let timeInterval: TimeInterval = timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }

    /// 格式化时间 NSDateFormatter
    private(set) static var dateformatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "zh_CN")
        df.timeZone = TimeZone(abbreviation: "UTC")!
        df.calendar = calendar
        return df
    }()
    /// 日历 NSCalendar
    private(set) static var calendar: Calendar = {
        var calender = Calendar(identifier: .gregorian)
        calender.locale = Locale(identifier: "zh_CN")
        calender.timeZone = TimeZone(abbreviation: "UTC")!
        return calender
    }()

}

enum PHDateWeekFormatter {
    // 一, 周一, 星期一, 礼拜一
    case x, xx, xxx, xxxx
}

struct PHDate<T> {
    var base: T
}

extension PHDate where T == Date {
    /// 10位时间戳
    var timestamp: Int {
        return Int(base.timeIntervalSince1970)
    }
    /// 13位时间戳
    var timestamp13: Int {
        return Int(base.timeIntervalSince1970 * 1000)
    }
    var dateComponent: DateComponents {
        let calendar = Calendar.current
        if let tz = TimeZone(abbreviation: "HKT") {  // "HKT": "Asia/Hong_Kong"
            return calendar.dateComponents(in: tz, from: base)
        } else {
            return calendar.dateComponents(in: TimeZone(abbreviation: "GMT+0800")!, from: base)
        }
    }

    var BeiJingDate: Date {
        var d = base
        d.addTimeInterval(TimeInterval(8 * 60 * 60))
        return d
    }

    /// 秒
    var second: Int {
        dateComponent.second ?? 0
    }
    /// 分
    var minute: Int {
        dateComponent.minute ?? 0
    }
    /// 时
    var hour: Int {
        dateComponent.hour ?? 0
    }
    /// 天
    var day: Int {
        dateComponent.day ?? 0
    }
    var weekday: Int {
        dateComponent.weekday ?? 0
    }
    /// 月
    var month: Int {
        dateComponent.month ?? 0
    }
    /// 年
    var year: Int {
        dateComponent.year ?? 0
    }

    func weekdayFormatter(_ weekformatter: PHDateWeekFormatter = .x) -> String {

        let weekDayStr: String
        switch dateComponent.weekday {
        case 1:
            weekDayStr = "日"
        case 2:
            weekDayStr = "一"
        case 3:
            weekDayStr = "二"
        case 4:
            weekDayStr = "三"
        case 5:
            weekDayStr = "四"
        case 6:
            weekDayStr = "五"
        default:
            weekDayStr = "六"
        }

        return weekDayStr
    }

    /// calendar offset
    /// - Parameters:
    ///   - unit: String, defualt is "dd"(day)
    ///   - offset: Int
    /// - Returns: Date
    func offset(unit: String = "dd", offset: Int) -> Date {
        var d = dateComponent
        switch unit {
        case "ss":
            d.second! += offset
        case "mm":
            d.minute! += offset
        case "HH":
            d.hour! += offset
        case "MM":
            d.month! += offset
        case "YYYY":
            d.year! += offset
        default:
            d.day! += offset
        }
        return Calendar.current.date(from: d) ?? Date()
    }
}

protocol PHDateCompatible {}

extension PHDateCompatible {
    var phDate: PHDate<Self> {
        PHDate(base: self)
    }
}

extension Date: PHDateCompatible {}

extension Date {
    // MARK: - 获取当前时区Date
    static func getCurrentDate() -> Date {
        let nowDate = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: nowDate)
        let localeDate = nowDate.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
}
