//
//  AuthViewModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

//
//  AuthViewModel.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI
import Combine
import CoreData

enum AuthMode: String, CaseIterable {
    case login = "Log In"
    case signup = "Sign Up"
}

final class AuthViewModel: ObservableObject {

    // Form Input States
    @Published var authMode: AuthMode = .login
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    // Alert & Navigation States
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isAuthenticated: Bool = false

    private let authManager = SessionManager.shared
    private let context = PersistenceController.shared.container.viewContext

    // Init
    init() {
        if authManager.isLoggedIn {
            self.isAuthenticated = true
        }
    }

    // Primary Action
    func handlePrimaryAction() {
        switch authMode {

        case .login:
            loginUser()

        case .signup:
            registerUser()
        }
    }

    // Login
    private func loginUser() {
        guard validateLoginInputs() else {
            return
        }

        let cleanEmail = email
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let user = fetchUserFromCoreData(email: cleanEmail) else {
            showError(AuthScreenConstants.noAccount)
            return
        }

        // Compare password
        if user.password == password {
            authManager.activeUserEmail = cleanEmail
            authManager.isLoggedIn = true
            isAuthenticated = true
        } else {
            showError(AuthScreenConstants.wrongPassword)
        }
    }

    // Register
    private func registerUser() {
        guard validateSignupInputs() else {
            return
        }

        let cleanEmail = email
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let cleanName = fullName
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if user already exists
        if fetchUserFromCoreData(email: cleanEmail) != nil {
            showError(AuthScreenConstants.accountExists)
            return
        }

        // Create new Core Data entity
        let newUser = User(context: context)
        newUser.id = UUID()
        newUser.name = cleanName
        newUser.email = cleanEmail
        newUser.password = password
        newUser.createdAt = Date()

        // Save Context
        do {
            try context.save()
            authManager.activeUserEmail = cleanEmail
            authManager.isLoggedIn = true
            isAuthenticated = true

        } catch {
            showError(
                "\(AuthScreenConstants.saveFailedPrefix)\(error.localizedDescription)"
            )
        }
    }

    // Fetch User
    private func fetchUserFromCoreData(email: String) -> User? {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()

        fetchRequest.predicate = NSPredicate(
            format: "email ==[c] %@",
            email
        )
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first

        } catch {
            print("Core Data fetch error: \(error)")
            return nil
        }
    }

    // Login Validation
    private func validateLoginInputs() -> Bool {

        // Login does not require full name.
        return validateInputs()
    }

    // Signup Validation
    private func validateSignupInputs() -> Bool {

        let cleanName = fullName
            .trimmingCharacters(in: .whitespacesAndNewlines)

        if cleanName.isEmpty {
            showError(AuthScreenConstants.nameRequired)
            return false
        }

        return validateInputs()
    }

    // Common Validation

    private func validateInputs() -> Bool {

        let cleanEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Email validation
        let emailRegex =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

        if cleanEmail.isEmpty {
            showError(AuthScreenConstants.emailRequired)
            return false
        }

        if cleanEmail.range(
            of: emailRegex,
            options: .regularExpression
        ) == nil {

            showError(AuthScreenConstants.emailInvalid)
            return false
        }

        // Password validation
        if password.isEmpty {
            showError(AuthScreenConstants.passwordRequired)
            return false
        }

        if password.count < 6 {
            showError(AuthScreenConstants.passwordTooShort)
            return false
        }

        return true
    }

    // Clear Fields

    func clearFields() {
        fullName = ""
        email = ""
        password = ""
        isPasswordVisible = false
        alertMessage = ""
        showAlert = false
        authMode = .login
    }

    // Logout
    func logout() {
        authManager.clearSession()
        clearFields()
        isAuthenticated = false
    }

    // Error
    private func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}
