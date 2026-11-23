//
//  SleepTrackerManager+Tracking.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import Foundation

extension SleepTrackerManager {

    func startSleepSession() {
        guard case .idle = currentState else {
            return
        }

        guard !userEmail.isEmpty else {
            return
        }

        let startTime = Date()

        userDefaults.set(
            startTime,
            forKey: sleepStartTimeKey
        )

        currentState = .tracking(
            startTime: startTime,
            elapsedTime: 0
        )

        startTimer(startTime: startTime)
    }

    func stopSleepSession() {
        guard case .tracking(let startTime, _) = currentState else {
            return
        }

        stopTimer()

        let endTime = Date()
        let elapsed = endTime.timeIntervalSince(startTime)

        if elapsed < 60 {
            resetTrackingState()
            return
        }

        let hours = min(
            elapsed / 3600,
            maxAllowedSleepHours
        )

        let roundedHours =
        (hours * 10).rounded() / 10

        if roundedHours > 0 {
            saveSleepRecord(
                durationHours: roundedHours,
                startTime: startTime,
                endTime: endTime
            )
        }

        resetTrackingState()
    }

    func discardSession() {
        resetTrackingState()
    }

    func restoreActiveSessionIfNeeded() {
        let savedStartTime: Date? =
        (userDefaults.object(forKey: sleepStartTimeKey) as? Date)
        ?? (userDefaults.object(forKey: Self.sleepStartTimeBaseKey) as? Date)

        guard let savedStartTime = savedStartTime else {
            currentState = .idle
            return
        }

        guard currentUser() != nil else {
            resetTrackingState()
            return
        }

        let now = Date()
        let elapsed = now.timeIntervalSince(savedStartTime)
        let elapsedHours = elapsed / 3600.0

        if elapsedHours >= maxAllowedSleepHours {
            let cappedEndTime = savedStartTime.addingTimeInterval(maxAllowedSleepHours * 3600.0)
            saveSleepRecord(durationHours: maxAllowedSleepHours, startTime: savedStartTime, endTime: cappedEndTime)
            resetTrackingState()
        } else if elapsed < 0 {
            resetTrackingState()
        } else {
            currentState = .tracking(startTime: savedStartTime, elapsedTime: elapsed)
            startForegroundTimer(startTime: savedStartTime)
        }
    }

    func resetTrackingState() {

        userDefaults.removeObject(
            forKey: sleepStartTimeKey
        )

        userDefaults.removeObject(
            forKey: Self.sleepStartTimeBaseKey
        )

        stopTimer()

        currentState = .idle
    }
}
