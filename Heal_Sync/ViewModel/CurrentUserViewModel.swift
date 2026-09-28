//
//  CurrentUserViewModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI
import CoreData
import Combine

/// Single source of truth for the logged-in user's identity.
/// Home (greeting) and Profile (user card) both read from here instead of
/// form fields or duplicated fetches.
///
/// Stale-session repair: if the session email is missing (e.g. a login state
/// persisted without it), the most recently created User is adopted and the
/// session is repaired, so the name shows instead of a blank.
final class CurrentUserViewModel: ObservableObject {

    @Published private(set) var name: String = ""
    @Published private(set) var email: String = ""
    @Published private(set) var memberSince: String = ""

    /// Full name for Profile, "—" when unknown.
    var displayName: String {
        name.isEmpty ? ProfileScreenConstants.unknownUser : name
    }

    /// First name for the Home greeting, "Friend" fallback.
    var firstName: String {
        let first = name.split(separator: " ").first.map(String.init) ?? ""
        return first.isEmpty ? HomeScreenConstants.Greetings.fallbackName : first
    }

    var initial: String {
        name.first.map { String($0).uppercased() } ?? "•"
    }

    func refresh() {
        let context = PersistenceController.shared.container.viewContext

        // 1. Normal path: resolve via the session email.
        let sessionEmail = SessionManager.shared.activeUserEmail
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        var user: NSManagedObject?
        if !sessionEmail.isEmpty {
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            request.predicate = NSPredicate(format: "email ==[c] %@", sessionEmail)
            request.fetchLimit = 1
            user = try? context.fetch(request).first
        }

        // 2. Repair: no session match → adopt the most recently created user.
        if user == nil {
            let request = NSFetchRequest<NSManagedObject>(entityName: "User")
            let all = (try? context.fetch(request)) ?? []
            user = all.max {
                (($0.value(forKey: "createdAt") as? Date) ?? .distantPast) <
                (($1.value(forKey: "createdAt") as? Date) ?? .distantPast)
            }
            if let adoptedEmail = user?.value(forKey: "email") as? String,
               !adoptedEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                SessionManager.shared.activeUserEmail = adoptedEmail.lowercased()
            }
        }

        guard let user else {
            name = ""
            email = ""
            memberSince = ""
            return
        }

        name = ((user.value(forKey: "name") as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines))
            .flatMap { $0.isEmpty ? nil : $0 } ?? ""
        email = (user.value(forKey: "email") as? String) ?? ""

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

    /// Updates the logged-in user's display name (trimmed, non-empty only).
    func updateName(_ newName: String) {
        let cleanName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }
        refresh()
        guard !email.isEmpty else { return }

        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        guard let user = try? context.fetch(request).first else { return }

        user.setValue(cleanName, forKey: "name")
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CurrentUserViewModel name save error: \(error)")
                context.rollback()
                return
            }
        }
        refresh()
    }
}
