//
//  Date+Extensions.swift
//  jaunt
//
//  Created by Travis Ma on 3/30/19.
//  Copyright © 2019 Travis Ma. All rights reserved.
//

import Foundation

extension Date {
    
    static let months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]
    
    static func daysCount(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents), let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return 0
    }
    
    func relativeDate() -> String {
        let formatter = RelativeDateTimeFormatter()
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func dates(untilDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = self
        while date <= untilDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    func dayOfWeek() -> Int {
        let cal = Calendar(identifier: .gregorian)
        return cal.component(.weekday, from: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    func daysUntil(date: Date) -> Int {
        let currentCalendar = Calendar.current
        if let start = currentCalendar.ordinality(of: .day, in: .era, for: self),
            let end = currentCalendar.ordinality(of: .day, in: .era, for: date) {
            return end - start
        }
        return 0
    }
    
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func daysSince(date: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: date, to: self)
        return components.day ?? 0
    }
    
    func adjustedBy(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func adjustedBy(hours: Int, minutes: Int) -> Date {
        let minuteDate = Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
        return Calendar.current.date(byAdding: .hour, value: hours, to: minuteDate) ?? self
    }
    
    func setTime(hours: Int, minutes: Int, useUtc: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var hrs = hours
        var mins = minutes
        var d = self
        if useUtc { //cuts the date portion off and uses as is instead of converting to user's timezone before applying hours/minutes
            let df = DateFormatter()
            df.timeZone = TimeZone(abbreviation: "UTC")
            df.dateFormat = "yyyy-MM-dd"
            let dateString = df.string(from: self)
            df.timeZone = TimeZone.current
            d = df.date(from: dateString) ?? self
        }
        if minutes > 60 {
            hrs += Int(floor(Double(minutes) / 60))
            mins = Int(Double(minutes).truncatingRemainder(dividingBy: 60))
        }
        if hrs > 24 {
            let days = Int(floor(Double(hrs) / 24))
            hrs = Int(Double(hrs).truncatingRemainder(dividingBy: 24))
            d = calendar.date(byAdding: .day, value: days, to: self) ?? self
        }
        if hrs == 24 {
            hrs = 23
            mins = 59
        }
        return calendar.date(bySettingHour: hrs, minute: mins, second: 0, of: d) ?? self
    }
    
    func zeroSeconds() -> Date {
        let time = floor(self.timeIntervalSinceReferenceDate / 60) * 60
        return Date(timeIntervalSinceReferenceDate: time)
    }
    
    func round(toNearestMinutes minutes: Int) -> Date {
        let calendar = Calendar.current
        let nextDiff = minutes - calendar.component(.minute, from: self) % minutes
        if nextDiff == minutes {
            return self
        }
        return calendar.date(byAdding: .minute, value: nextDiff, to: self) ?? self
    }
}

extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    
    private var seconds: Int {
        return Int(self) % 60
    }
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }
}
