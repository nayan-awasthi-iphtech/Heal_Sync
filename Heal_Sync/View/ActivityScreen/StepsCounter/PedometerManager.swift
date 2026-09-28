//
//  PedometerManager.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.

import Foundation
import CoreMotion
import Combine

@MainActor
class PedometerManager: ObservableObject {
    private let pedometer = CMPedometer()

    private var lastLiveSteps: Int = 0
    private var lastLiveDistance: Double = 0.0

    @Published var currentSteps: Int = 0
    @Published var distanceMeters: Double = 0.0

    private(set) var currentTimeframe: String = "Day"

    func seed(steps: Int, distance: Double) {
        currentSteps = steps
        distanceMeters = distance
        lastLiveSteps = 0
        lastLiveDistance = 0.0
    }

    func loadActivityData(for timeFrame: String) {
        currentTimeframe = timeFrame
        pedometer.stopUpdates() // Stop active streams before recalculating
        lastLiveSteps = 0
        lastLiveDistance = 0.0

        guard CMPedometer.isStepCountingAvailable() else { return }
        
        let now = Date()
        let calendar = Calendar.current
        let startDate: Date

        switch timeFrame {
        case "Day":
            startDate = calendar.startOfDay(for: now)
        case "Week":
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
            startDate = calendar.date(from: components) ?? calendar.startOfDay(for: now)
        case "Month":
            let components = calendar.dateComponents([.year, .month], from: now)
            startDate = calendar.date(from: components) ?? calendar.startOfDay(for: now)
        default:
            startDate = calendar.startOfDay(for: now)
        }

        // Query historical steps up to this exact moment
        pedometer.queryPedometerData(from: startDate, to: now) { [weak self] data, error in
            DispatchQueue.main.async {
                guard let self = self, error == nil, let data = data else { return }
                guard self.currentTimeframe == timeFrame else { return }
                
                self.currentSteps = data.numberOfSteps.intValue
                self.distanceMeters = data.distance?.doubleValue ?? (Double(self.currentSteps) * 0.75)
            }
        }

        // Only stream live hardware updates when viewing "Day"
        if timeFrame == "Day" {
            pedometer.startUpdates(from: now) { [weak self] liveData, error in
                DispatchQueue.main.async {
                    guard let self = self, error == nil, let liveData = liveData else { return }
                    guard self.currentTimeframe == "Day" else { return }

                    // Deliveries are cumulative since 'now' — add only the delta.
                    let totalSteps = liveData.numberOfSteps.intValue
                    let totalDistance = liveData.distance?.doubleValue ?? (Double(totalSteps) * 0.75)
                    let newSteps = max(0, totalSteps - self.lastLiveSteps)
                    let newDistance = max(0, totalDistance - self.lastLiveDistance)
                    self.lastLiveSteps = totalSteps
                    self.lastLiveDistance = totalDistance
                    self.currentSteps += newSteps
                    self.distanceMeters += newDistance
                }
            }
        }
    }

    func stopTracking() {
        pedometer.stopUpdates()
        lastLiveSteps = 0
        lastLiveDistance = 0.0
    }
}

// MARK: - Simulator Mock
class MockPedometerManager: PedometerManager {
    private var timer: Timer?

    override func loadActivityData(for timeFrame: String) {
        timer?.invalidate()
        super.loadActivityData(for: timeFrame)

        guard timeFrame == "Day" else { return }

        // Start from seeded base and accumulate live test steps on Simulator
        timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self, self.currentTimeframe == "Day" else { return }
                let newSteps = Int.random(in: 1...3)
                self.currentSteps += newSteps
                self.distanceMeters += Double(newSteps) * 0.75
            }
        }
    }

    override func stopTracking() {
        super.stopTracking()
        timer?.invalidate()
    }
}
