//
//  CurrentUserViewModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI
import CoreData
import Combine

@MainActor
final class CurrentUserViewModel: ObservableObject {

    @Published private(set) var name: String = ""
    @Published private(set) var email: String = ""
    @Published private(set) var memberSince: String = ""

    var displayName: String {
        name.isEmpty ? ProfileScreenConstants.unknownUser : name
    }

    /// First name for the Home greeting; falls back to default constant if empty.
    var firstName: String {
        let first = name.components(separatedBy: .whitespaces).first ?? ""
        return first.isEmpty ? HomeScreenConstants.Greetings.fallbackName : first
    }

    var initial: String {
        name.first.map { String($0).uppercased() } ?? "•"
    }

    func refresh() {
        let context = PersistenceController.shared.container.viewContext
        let sessionEmail = SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        var user: NSManagedObject?

        // Fetch user matching active session email
        if !sessionEmail.isEmpty {
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            request.predicate = NSPredicate(format: "email ==[c] %@", sessionEmail)
            request.fetchLimit = 1
            user = try? context.fetch(request).first
        }

        // Fallback: Adopt most recently created user if session mismatch
        if user == nil {
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            request.fetchLimit = 1
            user = try? context.fetch(request).first

            if let adoptedEmail = user?.value(forKey: "email") as? String,
               !adoptedEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                SessionManager.shared.activeUserEmail = adoptedEmail.lowercased()
            }
        }

        // Populate ViewModel properties
        guard let user = user else {
            name = ""
            email = ""
            memberSince = ""
            return
        }

        let rawName = user.value(forKey: "name") as? String ?? ""
        name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        email = user.value(forKey: "email") as? String ?? ""

        if let createdAt = user.value(forKey: "createdAt") as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            memberSince = String(
                format: ProfileScreenConstants.memberSinceFormat,
                formatter.string(from: createdAt)
            )
        } else {
            memberSince = ""
        }
    }

    // Updates the logged-in user's display name.
    func updateName(_ newName: String) {
        let cleanName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty, !email.isEmpty else { return }

        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1

        guard let user = try? context.fetch(request).first else { return }

        user.setValue(cleanName, forKey: "name")

        if context.hasChanges {
            do {
                try context.save()
                self.name = cleanName
            } catch {
                print("CurrentUserViewModel: Error saving name - \(error)")
                context.rollback()
            }
        }
    }
}
