//
//  HeartRateStore.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import Foundation
import CoreData

final class HeartRateStore {
    static let shared = HeartRateStore()

    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    private init() {}

    private func currentUser() -> NSManagedObject? {
        let email = SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty else { return nil }

        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    func saveReading(bpm: Int, at date: Date = Date()) {
        guard bpm >= 30 && bpm <= 220, let owner = currentUser() else { return }

        let entity = NSEntityDescription.entity(forEntityName: "HeartReading", in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(UUID(), forKey: "id")
        object.setValue(date, forKey: "timestamp")
        object.setValue(Int16(bpm), forKey: "bpm")
        object.setValue(owner, forKey: "owner")

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("HeartRateStore save error: \(error)")
                context.rollback()
            }
        }
    }

    func averageBPM(from start: Date, to end: Date) -> Double {
        guard let owner = currentUser() else { return 0 }
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        guard let endExclusive = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) else {
            return 0
        }

        let request = NSFetchRequest<NSManagedObject>(entityName: "HeartReading")
        request.predicate = NSPredicate(
            format: "owner == %@ AND timestamp >= %@ AND timestamp < %@",
            owner, startDay as NSDate, endExclusive as NSDate
        )

        guard let objects = try? context.fetch(request), !objects.isEmpty else { return 0 }
        let total = objects.reduce(0) { $0 + Int($1.value(forKey: "bpm") as? Int16 ?? 0) }
        return Double(total) / Double(objects.count)
    }

    func dailyAverageBPM(end: Date = Date(), days: Int = 7) -> [(date: Date, bpm: Double)] {
        let calendar = Calendar.current
        let endDay = calendar.startOfDay(for: end)
        var result: [(Date, Double)] = []
        for offset in stride(from: days - 1, through: 0, by: -1) {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: endDay),
                  let next = calendar.date(byAdding: .day, value: 1, to: date) else { continue }
            let dayEnd = calendar.date(byAdding: .second, value: -1, to: next) ?? date
            result.append((date, averageBPM(from: date, to: dayEnd)))
        }
        return result
    }
}
