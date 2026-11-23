//
//  SleepTrackerManager+Timer.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import Foundation
import Combine

extension SleepTrackerManager {

    func startTimer(startTime: Date) {
        stopTimer()

        timerCancellable = Timer.publish(
            every: 1.0,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] now in

            guard let self = self else {
                return
            }

            let elapsed =
            now.timeIntervalSince(startTime)

            if elapsed / 3600 >= maxAllowedSleepHours {
                stopSleepSession()
            } else {
                currentState = .tracking(
                    startTime: startTime,
                    elapsedTime: elapsed
                )
            }
        }
    }

    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    func startForegroundTimer(startTime: Date) {
        stopForegroundTimer()

        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self else { return }
                let elapsed = now.timeIntervalSince(startTime)

                if (elapsed / 3600.0) >= self.maxAllowedSleepHours {
                    self.stopSleepSession()
                } else {
                    self.currentState = .tracking(startTime: startTime, elapsedTime: elapsed)
                }
            }
    }

    private func stopForegroundTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
