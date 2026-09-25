//
//  ActivityStore.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import Foundation
import CoreData

final class ActivityStore {
    static let shared = ActivityStore()

    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    private init() {}

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func dayID(for date: Date) -> String {
        dayFormatter.string(from: date)
    }

    // MARK: - Current User
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

    // MARK: - Single Day CRUD
    func loadDay(dayID: String) -> (steps: Int, distance: Double)? {
        guard let owner = currentUser() else { return nil }

        let request = NSFetchRequest<NSManagedObject>(entityName: "ActivityDay")
        request.predicate = NSPredicate(format: "dayID == %@ AND owner == %@", dayID, owner)
        request.fetchLimit = 1

        guard let object = try? context.fetch(request).first else { return nil }
        let steps = (object.value(forKey: "steps") as? Int64).map(Int.init) ?? 0
        let distance = object.value(forKey: "distance") as? Double ?? 0.0
        return (steps, distance)
    }

    func saveDay(dayID: String, date: Date, steps: Int, distance: Double) {
        guard let owner = currentUser() else { return }

        let request = NSFetchRequest<NSManagedObject>(entityName: "ActivityDay")
        request.predicate = NSPredicate(format: "dayID == %@ AND owner == %@", dayID, owner)
        request.fetchLimit = 1

        let object = (try? context.fetch(request).first) ?? {
            let entity = NSEntityDescription.entity(forEntityName: "ActivityDay", in: context)!
            let newObj = NSManagedObject(entity: entity, insertInto: context)
            newObj.setValue(dayID, forKey: "dayID")
            newObj.setValue(Calendar.current.startOfDay(for: date), forKey: "date")
            newObj.setValue(owner, forKey: "owner")
            return newObj
        }()

        object.setValue(Int64(steps), forKey: "steps")
        object.setValue(distance, forKey: "distance")
        object.setValue(Date(), forKey: "updatedAt")

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ActivityStore save error: \(error)")
                context.rollback()
            }
        }
    }

    // MARK: - Range Aggregation
    func sumDays(from start: Date, to end: Date) -> (steps: Int, distance: Double) {
        guard let owner = currentUser() else { return (0, 0.0) }

        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: start)
        guard let endExclusive = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) else {
            return (0, 0.0)
        }

        let request = NSFetchRequest<NSManagedObject>(entityName: "ActivityDay")
        request.predicate = NSPredicate(
            format: "owner == %@ AND date >= %@ AND date < %@",
            owner, startDay as NSDate, endExclusive as NSDate
        )

        guard let objects = try? context.fetch(request) else { return (0, 0.0) }

        let totalSteps = objects.compactMap { $0.value(forKey: "steps") as? Int64 }.reduce(0, +)
        let totalDistance = objects.compactMap { $0.value(forKey: "distance") as? Double }.reduce(0.0, +)

        return (Int(totalSteps), totalDistance)
    }
}
