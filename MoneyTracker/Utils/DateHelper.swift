//
//  DateHelper.swift
//  MoneyTracker
//
//  日期格式化与统计区间
//

import Foundation

enum DateHelper {

    private static let dbFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone.current
        return f
    }()

    private static let displayDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy年M月d日"
        f.locale = Locale(identifier: "zh_CN")
        return f
    }()

    private static let displayShortFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M月d日"
        f.locale = Locale(identifier: "zh_CN")
        return f
    }()

    private static let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy年M月"
        f.locale = Locale(identifier: "zh_CN")
        return f
    }()

    /// 存库用字符串
    static func toDatabaseString(_ date: Date) -> String {
        dbFormatter.string(from: date)
    }

    /// 从数据库字符串解析
    static func fromDatabaseString(_ string: String?) -> Date? {
        guard let string = string else { return nil }
        return dbFormatter.date(from: string)
    }

    /// 显示：2026年2月20日
    static func displayDate(_ date: Date) -> String {
        displayDateFormatter.string(from: date)
    }

    /// 显示短：2月20日
    static func displayShort(_ date: Date) -> String {
        displayShortFormatter.string(from: date)
    }

    /// 显示月份：2026年2月
    static func displayMonth(_ date: Date) -> String {
        monthFormatter.string(from: date)
    }

    /// 本月第一天 00:00:00
    static func startOfMonth(_ date: Date = Date()) -> Date {
        let cal = Calendar.current
        return cal.date(from: cal.dateComponents([.year, .month], from: date)) ?? date
    }

    /// 本月最后一天 23:59:59
    static func endOfMonth(_ date: Date = Date()) -> Date {
        let cal = Calendar.current
        guard let nextMonth = cal.date(byAdding: .month, value: 1, to: startOfMonth(date)),
              let end = cal.date(byAdding: .second, value: -1, to: nextMonth) else { return date }
        return end
    }

    /// 今天 00:00:00
    static func startOfToday() -> Date {
        Calendar.current.startOfDay(for: Date())
    }

    /// 今天 23:59:59
    static func endOfToday() -> Date {
        let cal = Calendar.current
        let start = startOfToday()
        return cal.date(byAdding: .day, value: 1, to: start)!.addingTimeInterval(-1)
    }
}
