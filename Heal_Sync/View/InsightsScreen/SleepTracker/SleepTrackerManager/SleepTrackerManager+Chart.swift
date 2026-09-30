//
//  SleepTrackerManager+Chart.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import Foundation
import CoreData

extension SleepTrackerManager {

    private static let placeholderBaseline: [Double] = [7.75, 6.8, 7.5, 8.0, 6.5, 7.8, 7.0]

    func placeholderHours(for night: Date) -> Double {
        let weekday = Calendar.current.component(.weekday, from: night)
        return Self.placeholderBaseline[(weekday + 5) % 7]
    }

    func dailyHours(end: Date = Date(), days: Int = 7) -> [(date: Date, hours: Double)] {
        guard let owner = currentUser() else { return [] }
        let calendar = Calendar.current
        let endNight = calendar.startOfDay(for: end)
        
        guard let startNight = calendar.date(byAdding: .day, value: -(days - 1), to: endNight),
              let rangeEndExclusive = calendar.date(byAdding: .day, value: 1, to: endNight) else {
            return []
        }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "SleepRecord")
        request.predicate = NSPredicate(
            format: "owner == %@ AND date >= %@ AND date < %@",
            owner, startNight as NSDate, rangeEndExclusive as NSDate
        )
        
        let records = (try? viewContext.fetch(request)) ?? []
        
        var hoursByNight: [Date: Double] = [:]
        for record in records {
            if let date = record.value(forKey: "date") as? Date,
               let hours = record.value(forKey: "durationHours") as? Double {
                hoursByNight[date, default: 0.0] += hours
            }
        }
        
        // Map continuous range Mon-Sun
        var result: [(Date, Double)] = []
        for offset in 0..<days {
            if let night = calendar.date(byAdding: .day, value: offset, to: startNight) {
                let total = hoursByNight[night] ?? 0.0
                result.append((night, total))
            }
        }
        return result
    }
    
    func sumHours(from start: Date, to end: Date) -> Double {
        guard let owner = currentUser() else { return 0 }
        let calendar = Calendar.current
        let startNight = calendar.startOfDay(for: start)
        guard let endExclusive = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) else {
            return 0
        }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "SleepRecord")
        request.predicate = NSPredicate(
            format: "owner == %@ AND date >= %@ AND date < %@",
            owner, startNight as NSDate, endExclusive as NSDate
        )
        
        guard let objects = try? viewContext.fetch(request) else { return 0 }
        return objects.reduce(0.0) { $0 + ($1.value(forKey: "durationHours") as? Double ?? 0.0) }
    }
}
