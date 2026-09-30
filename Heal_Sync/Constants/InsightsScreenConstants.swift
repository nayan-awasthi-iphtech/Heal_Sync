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
    static let fitnessDisclaimer = "For fitness use only. Not for medical use."

    // Insight card for Calories Section for bottom Card

    static let keepItUp = "Keep it up!"
    static let healthyRange = "Your heart rate is in healthy range"
    static let caloriesKeepItUp = "Nice burn!"
    static let caloriesHealthyRange = "You're on track with today's calorie goal"

    // Insights card for Sleep Section for bottomCard

    static let title = "Rest & Recovery"
    static let message = "Consistent sleep of 7–9 hours improves physical recovery, mental clarity, and daily energy levels."

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

    // Sleep start/stop button

    static let start = "Start Sleep"
    static let stop = "Stop Sleep"

    // Health Section start puslse scan button

    static let startPulseScan = "Start Pulse Scan"

    // Cancel Button for Heart section PopUp
    static let cancel = "Cancel"

    // camer access label
    static let cameraAccess = "Camera Access"

    // Calories Section Bottom Card Text
    static let caloriesMsg = "No calories burned yet today. Start tracking to see progress."
    static let goalReachedT1 = "Goal reached —"
    static let goalReachedT2 = "of"
    static let goalReachedT3 = "kcal burned today."
    static let goalReachedT4 = "kcal — keep moving to hit your goal."

}
