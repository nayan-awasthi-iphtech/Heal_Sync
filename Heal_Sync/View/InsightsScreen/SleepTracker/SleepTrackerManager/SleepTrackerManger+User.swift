//
//  SleepTrackerManger+User.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import Foundation
import CoreData

extension SleepTrackerManager {

    var userEmail: String {
        SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var sleepStartTimeKey: String {
        let email = SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { return Self.sleepStartTimeBaseKey }
        return "\(Self.sleepStartTimeBaseKey)_\(email)"
    }

    var touchedNightsKey: String {
        let email = SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { return "SleepTracker_touchedNights" }
        return "SleepTracker_touchedNights_\(email)"
    }

    static func dayID(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func currentUser() -> NSManagedObject? {
        guard !userEmail.isEmpty else {
            return nil
        }

        let request = NSFetchRequest<NSManagedObject>(
            entityName: "User"
        )

        request.predicate = NSPredicate(
            format: "email ==[c] %@",
            userEmail
        )

        request.fetchLimit = 1

        return try? viewContext.fetch(request).first
    }
}
