//
//  ProfileViewModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

//
//  ProfileViewModel.swift
//  Heal_Sync
//

import SwiftUI
import CoreData
import Combine

final class ProfileViewModel: ObservableObject {

    // Published Properties
    @Published var selectedRange: String = ActivityScreenConstants.day
    let ranges = [
        ActivityScreenConstants.day,
        ActivityScreenConstants.week,
        ActivityScreenConstants.month
    ]

    @Published private(set) var userName: String = ProfileScreenConstants.unknownUser
    @Published private(set) var userEmail: String = ""
    @Published private(set) var memberSince: String = ""

    @Published private(set) var steps: Int = 0
    @Published private(set) var distanceMeters: Double = 0.0

    private let store = ActivityStore.shared

    // Computed Properties
    var userInitial: String {
        userName.first.map { String($0).uppercased() } ?? "•"
    }

    var todayTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    var stepsFormatted: String { steps.formatted() }

    var distanceKmFormatted: String {
        let km = distanceMeters > 0 ? (distanceMeters / 1000.0) : (Double(steps) * 0.00075)
        return String(format: "%.1f km", km)
    }

    var caloriesValue: Int { Int(Double(steps) * 0.043) }
    var caloriesFormatted: String { "\(caloriesValue) kcal" }

    var activeMinutesValue: Int { Int(Double(steps) / 100.0) }
    var activeMinutesFormatted: String { "\(activeMinutesValue) min" }

    var stepGoal: Int {
        switch selectedRange {
        case "Day": return 10000
        case "Week": return 70000
        case "Month": return 300000
        default: return 10000
        }
    }

    var stepGoalText: String { "/\(stepGoal.formatted())" }

    var calorieGoal: Int {
        switch selectedRange {
        case "Day": return 500
        case "Week": return 3500
        case "Month": return 15000
        default: return 500
        }
    }

    var calorieGoalText: String { "of \(calorieGoal.formatted()) kcal" }

    var stepsProgress: Double {
        min(max(Double(steps) / Double(stepGoal), 0), 1)
    }

    var caloriesProgress: Double {
        min(max(Double(caloriesValue) / Double(calorieGoal), 0), 1)
    }

    var rangeSubtitle: String {
        switch selectedRange {
        case "Day": return ProfileScreenConstants.daySubtitle
        case "Week": return ProfileScreenConstants.weekSubtitle
        case "Month": return ProfileScreenConstants.monthSubtitle
        default: return ""
        }
    }

    // Refresh Logic
    func refresh() {
        loadUser()
        loadStats()
    }

    private func loadUser() {
        let email = SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { return }

        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1

        guard let user = try? context.fetch(request).first else { return }

        let name = (user.value(forKey: "name") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        userName = (name?.isEmpty == false) ? name! : "—"
        userEmail = (user.value(forKey: "email") as? String) ?? email

        if let createdAt = user.value(forKey: "createdAt") as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            memberSince = String(format: ProfileScreenConstants.memberSinceFormat, formatter.string(from: createdAt))
        } else {
            memberSince = ""
        }
    }

    private func loadStats() {
        let now = Date()
        if selectedRange == "Day" {
            let record = store.loadDay(dayID: ActivityStore.dayID(for: now))
            steps = record?.steps ?? 0
            distanceMeters = record?.distance ?? 0.0
        } else {
            let result = store.sumDays(from: rangeStart(for: selectedRange, now: now), to: now)
            steps = result.steps
            distanceMeters = result.distance
        }
    }

    private func rangeStart(for range: String, now: Date) -> Date {
        let calendar = Calendar.current
        switch range {
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
}
