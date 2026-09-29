//
//  SleepTrackerManager.swift
//  Heal_Sync
//

import Foundation
import Combine
import CoreData

enum SleepTrackerState: Equatable {
    case idle
    case tracking(
        startTime: Date,
        elapsedTime: TimeInterval
    )
    case confirming(
        startTime: Date,
        endTime: Date,
        calculatedHours: Double
    )
}

final class SleepTrackerManager: ObservableObject {
    
    @Published var currentState: SleepTrackerState = .idle
    @Published var sleepVersion: Int = 0
    
    let viewContext: NSManagedObjectContext
    let userDefaults: UserDefaults
    
    let maxAllowedSleepHours: Double = 16.0
    
    var timerCancellable: AnyCancellable?
    
    static let sleepStartTimeBaseKey = "SleepTracker_startTimeKey"
    
    init(
        context: NSManagedObjectContext,
        defaults: UserDefaults = .standard
    ) {
        self.viewContext = context
        self.userDefaults = defaults
        
        restoreActiveSessionIfNeeded()
    }
    
    deinit {
        timerCancellable?.cancel()
    }
    
    static func removePendingSession(defaults: UserDefaults = .standard, email: String?) {
        let clean = (email ?? "").lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if !clean.isEmpty {
            defaults.removeObject(forKey: "\(sleepStartTimeBaseKey)_\(clean)")
            defaults.removeObject(forKey: "SleepTracker_touchedNights_\(clean)")
        }
        defaults.removeObject(forKey: sleepStartTimeBaseKey)
        defaults.removeObject(forKey: "SleepTracker_touchedNights")
    }
}
