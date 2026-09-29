//
//  SleepTrackerManager+SleepData.swift.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import Foundation
import CoreData

extension SleepTrackerManager {
    
    func saveSleepRecord(durationHours: Double, startTime: Date, endTime: Date) {
        guard let owner = currentUser() else { return }
        let nightDate = Calendar.current.startOfDay(for: startTime)
        let ownerID = owner.objectID
        
        viewContext.performAndWait { [weak self] in
            guard let self = self else { return }
            
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "SleepRecord", into: self.viewContext)
            
            newRecord.setValue(UUID(), forKey: "id")
            newRecord.setValue(nightDate, forKey: "date")
            let props = newRecord.entity.propertiesByName
            if props["startTime"] != nil {
                newRecord.setValue(startTime, forKey: "startTime")
            }
            if props["endTime"] != nil {
                newRecord.setValue(endTime, forKey: "endTime")
            }
            newRecord.setValue(durationHours, forKey: "durationHours")
            newRecord.setValue(false, forKey: "isDummy")
            if let ownerObj = try? self.viewContext.existingObject(with: ownerID) {
                newRecord.setValue(ownerObj, forKey: "owner")
            }
            
            do {
                if self.viewContext.hasChanges {
                    try self.viewContext.save()
                }
                self.markTouchedNight(nightDate)
                self.sleepVersion += 1
            } catch {
                print("Failed to save SleepRecord: \(error.localizedDescription)")
                self.viewContext.rollback()
            }
        }
    }
    
    func saveNight(_ night: Date, hours: Double) {
        let nightStart = Calendar.current.startOfDay(for: night)
        let clamped = min(max(hours, 0), maxAllowedSleepHours)
        let rounded = (clamped * 10).rounded() / 10
        replaceNightRecords(nightStart: nightStart, hours: rounded)
        markTouchedNight(nightStart)
        sleepVersion += 1
    }
    
    func clearNight(_ night: Date) {
        let nightStart = Calendar.current.startOfDay(for: night)
        replaceNightRecords(nightStart: nightStart, hours: 0)
        markTouchedNight(nightStart)
        sleepVersion += 1
    }
    
    func replaceNightRecords(nightStart: Date, hours: Double) {
        guard let owner = currentUser() else { return }
        let ownerID = owner.objectID
        guard let nextNight = Calendar.current.date(byAdding: .day, value: 1, to: nightStart) else { return }
        
        viewContext.performAndWait { [weak self] in
            guard let self = self else { return }
            let request = NSFetchRequest<NSManagedObject>(entityName: "SleepRecord")
            request.predicate = NSPredicate(
                format: "owner == %@ AND date >= %@ AND date < %@",
                owner, nightStart as NSDate, nextNight as NSDate
            )
            for obj in (try? self.viewContext.fetch(request)) ?? [] {
                self.viewContext.delete(obj)
            }
            if hours > 0 {
                let rec = NSEntityDescription.insertNewObject(forEntityName: "SleepRecord", into: self.viewContext)
                rec.setValue(UUID(), forKey: "id")
                rec.setValue(nightStart, forKey: "date")
                let props = rec.entity.propertiesByName
                if props["startTime"] != nil { rec.setValue(nightStart, forKey: "startTime") }
                if props["endTime"] != nil {
                    rec.setValue(nightStart.addingTimeInterval(hours * 3600), forKey: "endTime")
                }
                rec.setValue(hours, forKey: "durationHours")
                rec.setValue(false, forKey: "isDummy")
                if let ownerObj = try? self.viewContext.existingObject(with: ownerID) {
                    rec.setValue(ownerObj, forKey: "owner")
                }
            }
            do {
                if self.viewContext.hasChanges { try self.viewContext.save() }
            } catch {
                print("Failed to update SleepRecord: \(error.localizedDescription)")
                self.viewContext.rollback()
            }
        }
    }
    
    func markTouchedNight(_ nightStart: Date) {
        var ids = userDefaults.stringArray(forKey: touchedNightsKey) ?? []
        let id = Self.dayID(for: nightStart)
        if !ids.contains(id) {
            ids.append(id)
            userDefaults.set(ids, forKey: touchedNightsKey)
        }
    }
    
    func isTouchedNight(_ night: Date) -> Bool {
        let id = Self.dayID(for: Calendar.current.startOfDay(for: night))
        return (userDefaults.stringArray(forKey: touchedNightsKey) ?? []).contains(id)
    }
}
