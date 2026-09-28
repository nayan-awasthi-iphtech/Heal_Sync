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
    static let heartEmptyState = "No heart readings yet. Tap Start Pulse Scan."
    static let cameraDeniedMessage = "Camera access is off. Allow it in Settings to measure heart rate."
    static let scanningText = "Scanning… keep your finger steady"
    static let placeFingerText = "Cover the camera and flash with your finger"

    // Insight card

    static let keepItUp = "Keep it up!"
    static let healthyRange = "Your hear rate is in healthy range"
    static let caloriesKeepItUp = "Nice burn!"
    static let caloriesHealthyRange = "You're on track with today's calorie goal"

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

    // Calories card (labels only — values come from ActivityStore/ActivityViewModel)

    static let caloriesTitle = "Calories"
    static let kcalUnit = "kcal"
    static let caloriesGoalLabel = "goal"
    static let caloriesEmptyState = "No calorie data yet. Start tracking in the Activity tab."
    static let thisWeekTitle = "This Week"
    static let dailyAvgTitle = "Daily Avg"

    // Sleep card (simple placeholder — no sleep tracking source yet)

    static let sleepTitle = "Sleep"
    static let sleepValue = "7h 20m"
    static let sleepBadge = "Good"
    static let sleepGoalLabel = "of 8h goal"
    static let bedtimeTitle = "Bedtime"
    static let bedtimeValue = "11:00 PM"
    static let wakeTitle = "Wake up"
    static let wakeValue = "6:20 AM"
}
