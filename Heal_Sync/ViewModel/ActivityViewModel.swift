//
//  ActivityViewModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI
import Combine

final class ActivityViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var selectedTab: String = "Day"
    let options = ["Day", "Week", "Month"]

    @Published private(set) var currentSteps: Int = 0
    @Published private(set) var distanceMeters: Double = 0.0
    @Published private(set) var lastUpdated: Date = Date()

    @Published private(set) var todaySteps: Int = 0
    @Published private(set) var todayDistanceMeters: Double = 0.0

    static let dayStepGoal = 10000
    static let dayCalorieGoal = 500

    private let pedometer: PedometerManager
    private let store = ActivityStore.shared
    private var cancellables = Set<AnyCancellable>()

    init(pedometer: PedometerManager? = nil) {
        #if targetEnvironment(simulator)
        self.pedometer = pedometer ?? MockPedometerManager()
        #else
        self.pedometer = pedometer ?? PedometerManager()
        #endif

        setupObservers()
    }

    // MARK: - Bindings
    private func setupObservers() {
        // Sync steps from sensor layer and persist today's metrics
        pedometer.$currentSteps
            .dropFirst()
            .sink { [weak self] steps in
                guard let self = self else { return }
                self.currentSteps = steps
                self.lastUpdated = Date()
                if self.selectedTab == "Day" {
                    self.todaySteps = steps
                }
                self.persistToday()
            }
            .store(in: &cancellables)

        // Sync distance from sensor layer
        pedometer.$distanceMeters
            .dropFirst()
            .sink { [weak self] distance in
                guard let self = self else { return }
                self.distanceMeters = distance
                self.lastUpdated = Date()
                if self.selectedTab == "Day" {
                    self.todayDistanceMeters = distance
                }
                self.persistToday()
            }
            .store(in: &cancellables)
    }

    // MARK: - Computed Properties
    var targetGoal: Int {
        switch selectedTab {
        case "Day": return 10000
        case "Week": return 70000
        case "Month": return 300000
        default: return 10000
        }
    }

    var distanceKmFormatted: String {
        let km = distanceMeters > 0 ? (distanceMeters / 1000.0) : (Double(currentSteps) * 0.00075)
        return String(format: "%.1f", km)
    }

    var activeCaloriesFormatted: String {
        "\(Int(Double(currentSteps) * 0.043))"
    }

    var activeMinutesFormatted: String {
        "\(Int(Double(currentSteps) / 100.0))"
    }

    // MARK: - Home Card Metrics
    var todayStepsFormatted: String {
        todaySteps.formatted()
    }

    var todayCaloriesValue: Int {
        Int(Double(todaySteps) * 0.043)
    }

    var todayCaloriesFormatted: String {
        "\(todayCaloriesValue) kcal"
    }

    var todayStepsProgress: Double {
        min(max(Double(todaySteps) / Double(Self.dayStepGoal), 0), 1)
    }

    var todayCaloriesProgress: Double {
        min(max(Double(todayCaloriesValue) / Double(Self.dayCalorieGoal), 0), 1)
    }

    // MARK: - Persistence & Range Calculation
    private var todayID: String {
        ActivityStore.dayID(for: Date())
    }

    private func restoreToday() {
        if let record = store.loadDay(dayID: todayID) {
            currentSteps = record.steps
            distanceMeters = record.distance
        } else {
            currentSteps = 0
            distanceMeters = 0.0
        }
        todaySteps = currentSteps
        todayDistanceMeters = distanceMeters
        lastUpdated = Date()
    }

    private func persistToday() {
        guard selectedTab == "Day" else { return }
        store.saveDay(dayID: todayID, date: Date(), steps: currentSteps, distance: distanceMeters)
    }

    private func rangeStart(for timeFrame: String, now: Date = Date()) -> Date {
        let calendar = Calendar.current
        switch timeFrame {
        case "Week":
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
            return calendar.date(from: components) ?? calendar.startOfDay(for: now)
        case "Month":
            let components = calendar.dateComponents([.year, .month], from: now)
            return calendar.date(from: components) ?? calendar.startOfDay(for: now)
        default:
            return calendar.startOfDay(for: now)
        }
    }

    private func showRangeSum(for timeFrame: String) {
        let now = Date()
        let result = store.sumDays(from: rangeStart(for: timeFrame, now: now), to: now)
        currentSteps = result.steps
        distanceMeters = result.distance
        lastUpdated = Date()
    }

    // MARK: - View Lifecycle & Lifecycle Intents
    func loadActivityData(for timeFrame: String) {
        selectedTab = timeFrame

        if timeFrame == "Day" {
            restoreToday()
            pedometer.seed(steps: currentSteps, distance: distanceMeters)
            pedometer.loadActivityData(for: timeFrame)
        } else {
            pedometer.loadActivityData(for: timeFrame)
            showRangeSum(for: timeFrame)
        }
    }

    func onAppear() {
        loadActivityData(for: selectedTab)
    }

    func onDisappear() {
        persistToday()
        pedometer.stopTracking()
    }
}
