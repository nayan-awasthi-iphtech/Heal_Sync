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
    private var activeRequest: UUID?

    @Published var currentSteps: Int = 0
    @Published var distanceMeters: Double = 0.0
    @Published var lastError: String?
    @Published var isAvailable: Bool = true
    @Published var isPermissionDenied: Bool = false

    private(set) var currentTimeframe: String = "Day"

    func seed(steps: Int, distance: Double) {
        currentSteps = steps
        distanceMeters = distance
        lastLiveSteps = 0
        lastLiveDistance = 0.0
    }

    private func friendlyMessage(for error: Error) -> String {
        let nsError = error as NSError
        if nsError.domain == "CMErrorDomain" && nsError.code == 105 {
            return "Motion access denied (105). Allow Motion & Fitness for Heal_Sync in Settings, then tap Start again."
        }
        return nsError.localizedDescription
    }
    
    func loadActivityData(for timeFrame: String) {
        pedometer.stopUpdates()
        activeRequest = nil
        currentTimeframe = timeFrame
        lastLiveSteps = 0
        lastLiveDistance = 0.0
        lastError = nil
        isPermissionDenied = false
        isAvailable = CMPedometer.isStepCountingAvailable()
        guard isAvailable else { return }
        if #available(iOS 11.0, *) {
            let status = CMPedometer.authorizationStatus()
            if status == .denied || status == .restricted {
                isPermissionDenied = true
                lastError = "Motion access denied (105). Allow Motion & Fitness for Heal_Sync in Settings, then tap Start again."
                return
            }
        }

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

        let request = UUID()
        activeRequest = request
        pedometer.queryPedometerData(from: startDate, to: now) { [weak self] data, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard self.activeRequest == request else { return }
                guard self.currentTimeframe == timeFrame else { return }
                if let error = error {
                    let nsError = error as NSError
                    if nsError.domain == "CMErrorDomain" && nsError.code == 105 {
                        self.isPermissionDenied = true
                    }
                    self.lastError = self.friendlyMessage(for: error)
                    return
                }
                guard let data = data else {
                    self.lastError = "Unable to read motion data."
                    return
                }
                self.currentSteps = data.numberOfSteps.intValue
                self.distanceMeters = data.distance?.doubleValue ?? (Double(self.currentSteps) * 0.75)
                guard timeFrame == "Day" else { return }
                self.pedometer.startUpdates(from: now) { [weak self] liveData, error in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        guard self.activeRequest == request else { return }
                        if let error = error {
                            let nsError = error as NSError
                            if nsError.domain == "CMErrorDomain" && nsError.code == 105 {
                                self.isPermissionDenied = true
                            }
                            self.lastError = self.friendlyMessage(for: error)
                            return
                        }
                        guard let liveData = liveData else { return }
                        guard self.currentTimeframe == "Day" else { return }
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
    }

    func stopTracking() {
        activeRequest = nil
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
        isAvailable = true
        lastError = nil
        isPermissionDenied = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else {return}
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
