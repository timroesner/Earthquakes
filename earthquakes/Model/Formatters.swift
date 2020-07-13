//
//  Formatters.swift
//  earthquakes
//
//  Created by Tim Roesner on 7/7/20.
//

import Foundation

extension Date {
    func relativeToNow() -> String {
        let day: TimeInterval = 60 * 60 * 24
        if abs(timeIntervalSinceNow) > day {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: self)
        } else {
            let formatter = RelativeDateTimeFormatter()
            return formatter.localizedString(for: self, relativeTo: Date())
        }
    }
}

extension Double {
    func fraction(minDigits: Int, maxDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minDigits
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
