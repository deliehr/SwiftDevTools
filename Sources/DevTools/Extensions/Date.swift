//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

extension Date {
    var beginOfDay: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)
    }

    func dateComponents(from fromComponents: Set<Calendar.Component>) -> DateComponents {
        Calendar.current.dateComponents(fromComponents, from: self)
    }

    func countDays(from: Date) -> Int {
        Calendar.current.dateComponents([.day], from: from, to: self).day ?? 0
    }

    func asString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

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
