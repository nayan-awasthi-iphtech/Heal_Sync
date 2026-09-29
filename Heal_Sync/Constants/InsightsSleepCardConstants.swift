//
//  InsightsSleepCardConstants.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct InsightsSleepCardConstants {
    static let pickerTitle = "Select Period"
    static let score = "score"
    static let sleepInsights = "Sleep Insight"

    static let tonightScore = 82
    static let tonightDuration = "7h 45m"
    static let tonightInsight1 = "Sleep quality dropped compared to last week."
    static let tonightInsight2 = "Avoid intense late workouts to support better recovery tonight."

    static let weeklyScore = 86
    static let weeklyDuration = "7h 52m avg"
    static let weeklyInsight1 = "Consistent sleep schedule maintained across 5 days."
    static let weeklyInsight2 = "Deep sleep increased by 12% compared to last week."

    static let monthlyScore = 79
    static let monthlyDuration = "7h 15m avg"
    static let monthlyInsight1 = "Overall recovery score is slightly below target."
    static let monthlyInsight2 = "Weekend sleep duration was higher than weekday averages."

    static func mockData(for period: SleepFilterPeriod) -> SleepDataModel {
        switch period {
        case .tonight:
            return SleepDataModel(
                filterPeriod: .tonight,
                score: tonightScore,
                sleepDuration: tonightDuration,
                insights: [tonightInsight1, tonightInsight2]
            )
        case .weekly:
            return SleepDataModel(
                filterPeriod: .weekly,
                score: weeklyScore,
                sleepDuration: weeklyDuration,
                insights: [weeklyInsight1, weeklyInsight2]
            )
        case .monthly:
            return SleepDataModel(
                filterPeriod: .monthly,
                score: monthlyScore,
                sleepDuration: monthlyDuration,
                insights: [monthlyInsight1, monthlyInsight2]
            )
        }
    }
}
