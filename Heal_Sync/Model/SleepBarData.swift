//
//  SleepBarData.swift
//  Heal_Sync
//

import Foundation

struct SleepBarData: Identifiable {
    // Stable identity per night so Chart doesn't treat every refresh as new bars.
    var id: Date { Calendar.current.startOfDay(for: date) }
    let dayLabel: String     // "Mon", "Tue", etc.
    let date: Date
    let hours: Double
    let isToday: Bool
    let isLive: Bool
    let isDummy: Bool
}
