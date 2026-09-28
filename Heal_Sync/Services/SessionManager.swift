//
//  SessionManager.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import Foundation

final class SessionManager{
    
    static let shared = SessionManager()
    private let defaults = UserDefaults.standard
    
    private let loggedInUserKey = "User_logged_in"
    private let currentUserEmail = "user_current_email"
    private let completedOnboardingKey = "has_completed_onboarding"
    
    private init() {}
    
    var isLoggedIn: Bool {
        get{defaults.bool(forKey: loggedInUserKey)}
        set{ defaults.set(newValue, forKey: loggedInUserKey)}
    }
    
    var activeUserEmail: String {
        get { defaults.string(forKey: currentUserEmail) ?? ""}
        set {defaults.set(newValue, forKey: currentUserEmail)}
    }
    
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: completedOnboardingKey) }
        set { defaults.set(newValue, forKey: completedOnboardingKey) }
    }
    
    func clearSession(){
        defaults.set(false, forKey: loggedInUserKey)
        defaults.removeObject(forKey: currentUserEmail)
    }
}
