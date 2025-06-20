//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

public extension Date {
    var beginOfDay: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)
    }

    var endOfDay: Date? {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59

        return calendar.date(from: components)
    }

    func dateComponents(from fromComponents: Set<Calendar.Component>) -> DateComponents {
        Calendar.current.dateComponents(fromComponents, from: self)
    }

    func countDays(from: Date) -> Int {
        Calendar.current.dateComponents([.day], from: from, to: self).day ?? 0
    }

    func asString(_ format: String, timeZone: TimeZone = .current, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale

        return formatter.string(from: self)
    }

    func startOfWeek(addingDays: Int? = nil) -> Date? {
        customDate(weekday: Calendar.current.firstWeekday, addingDays: addingDays)
    }

    func endOfWeek(addingDays: Int? = nil) -> Date? {
        customDate(weekday: Calendar.current.lastWeekday, addingDays: addingDays)
    }

    func adding(days: Int) -> Date? {
        Calendar.current.date(byAdding: DateComponents(day: days), to: self)
    }

    mutating func add(days: Int) {
        self = adding(days: days) ?? Date()
    }

    private func customDate(weekday: Int, addingDays: Int? = nil) -> Date? {
        let calendar = Calendar.current

        var components = self.dateComponents(from: [.month, .year, .weekOfMonth])
        components.weekday = weekday

        var newDate = calendar.date(from: components)

        if let addingDays, let date = newDate {
            var components = DateComponents()
            components.day = addingDays

            newDate = calendar.date(byAdding: components, to: date)
        }

        return newDate
    }

    func isOnSameDay(as referenceDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: referenceDate)
    }
}
