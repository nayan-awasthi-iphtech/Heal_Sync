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
    
    init() {
        if authManager.isLoggedIn {
            self.isAuthenticated = true
        }
    }
    
    func handlePrimaryAction() {
        guard validateInputs() else { return }
        
        switch authMode {
        case .login:
            loginUser()
        case .signup:
            registerUser()
        }
    }
    
    // Login
    private func loginUser() {
        let cleanEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let user = fetchUserFromCoreData(email: cleanEmail) else {
            showError("No account found with this email.")
            return
        }
        
        // Compare password
        if user.password == password {
            authManager.activeUserEmail = cleanEmail
            authManager.isLoggedIn = true
            isAuthenticated = true
        } else {
            showError("Incorrect password.")
        }
    }
    
    // Register
    private func registerUser() {
        let cleanEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if user already exists in Core Data
        if fetchUserFromCoreData(email: cleanEmail) != nil {
            showError("An account with this email already exists.")
            return
        }
        
        // Create new Core Data Entity
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
            showError("Failed to save account: \(error.localizedDescription)")
        }
    }
    
    // Fetching User
    private func fetchUserFromCoreData(email: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email ==[c] %@", email)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Core Data fetch error: \(error)")
            return nil
        }
    }
    
    // Input Validation
    private func validateInputs() -> Bool {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if authMode == .signup && fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showError("Please enter your full name.")
            return false
        }
        
        if cleanEmail.isEmpty || !cleanEmail.contains("@") {
            showError("Please enter a valid email address.")
            return false
        }
        
        if password.count < 6 {
            showError("Password must be at least 6 characters long.")
            return false
        }
        
        return true
    }
    
    func clearFields(){
        fullName = ""
        email = ""
        password = ""
        isPasswordVisible = false
        alertMessage = ""
        showAlert = false
        authMode = .login
    }

    func logout() {
        authManager.clearSession()
        clearFields()
        isAuthenticated = false
    }
    
    private func showError(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}
