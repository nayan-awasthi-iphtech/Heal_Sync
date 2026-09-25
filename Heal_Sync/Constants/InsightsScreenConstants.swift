//
//  InsightsScreenConstants.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI

struct InsightsScreenConstants {

    // Title and subtitle

    static let mainTitle = "Insights"
    static let subtitle = "Understand Today, Build a better tomorrow"

    // Picker

    static let health = "Health"
    static let sleep = "Sleep"
    static let calories = "Calories"

    // Heart-rate card

    static let heartRate = "Heart Rate"
    static let bpmUnit = "bpm"
    static let vsLastWeek = "vs. last week"
    static let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    // Insight card

    static let keepItUp = "Keep it up!"
    static let healthyRange = "Your hear rate is in healthy range"

    // Icons (SF Symbols)

    struct Images {
        static let heartFill = "heart.fill"
        static let chevronRight = "chevron.right"
        static let trendUp = "arrow.up"
        static let bulb = "lightbulb.fill"
    }

    // Change badge & chart scale (numeric display tokens)

    static let changePercent = "2%"
    static let chartLevels = ["120", "80", "40", "0"]
}
