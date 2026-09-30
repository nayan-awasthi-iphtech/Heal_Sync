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
    @Published private(set) var profileImageData: Data?
    @Published private(set) var heightCm: Double = 0
    @Published private(set) var weightKg: Double = 0

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

    var profileUIImage: UIImage? {
        guard let data = profileImageData else { return nil }
        return UIImage(data: data)
    }

    var heightFormatted: String {
        heightCm > 0 ? String(format: "%.1f %@", heightCm, ProfileScreenConstants.cmUnit) : ProfileScreenConstants.notSet
    }

    var weightFormatted: String {
        weightKg > 0 ? String(format: "%.1f %@", weightKg, ProfileScreenConstants.kgUnit) : ProfileScreenConstants.notSet
    }

    var bmiValue: Double {
        guard heightCm > 0, weightKg > 0 else { return 0 }
        let m = heightCm / 100.0
        return weightKg / (m * m)
    }

    var bmiFormatted: String {
        bmiValue > 0 ? String(format: "%.1f", bmiValue) : ProfileScreenConstants.notSet
    }

    var bmiCategory: String {
        guard bmiValue > 0 else { return ProfileScreenConstants.notSet }
        if bmiValue < 18.5 { return ProfileScreenConstants.bmiUnderweight }
        if bmiValue < 25 { return ProfileScreenConstants.bmiHealthy }
        if bmiValue < 30 { return ProfileScreenConstants.bmiOverweight }
        return ProfileScreenConstants.bmiObese
    }

    var bmiCategoryColor: Color {
        guard bmiValue > 0 else { return .gray }
        if bmiValue < 18.5 { return .blue }
        if bmiValue < 25 { return Color(red: 0.30, green: 0.92, blue: 0.65) }
        if bmiValue < 30 { return .orange }
        return .red
    }

    func refresh() {
        let context = PersistenceController.shared.container.viewContext
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

        guard let user = user else {
            name = ""
            email = ""
            memberSince = ""
            profileImageData = nil
            heightCm = 0
            weightKg = 0
            return
        }

        let rawName = user.value(forKey: "name") as? String ?? ""
        name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        email = user.value(forKey: "email") as? String ?? ""
        profileImageData = user.value(forKey: "profileImage") as? Data
        heightCm = user.value(forKey: "heightCm") as? Double ?? 0
        weightKg = user.value(forKey: "weightKg") as? Double ?? 0

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

    func updateProfileImage(_ data: Data?) {
        guard !email.isEmpty else { return }
        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        guard let user = try? context.fetch(request).first else { return }
        user.setValue(data, forKey: "profileImage")
        if context.hasChanges {
            do {
                try context.save()
                self.profileImageData = data
            } catch {
                context.rollback()
            }
        }
    }

    func updateBody(heightCm: Double, weightKg: Double) {
        guard !email.isEmpty else { return }
        guard heightCm >= 0, weightKg >= 0, heightCm < 300, weightKg < 500 else { return }
        let context = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        guard let user = try? context.fetch(request).first else { return }
        user.setValue(heightCm, forKey: "heightCm")
        user.setValue(weightKg, forKey: "weightKg")
        if context.hasChanges {
            do {
                try context.save()
                self.heightCm = heightCm
                self.weightKg = weightKg
            } catch {
                context.rollback()
            }
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
