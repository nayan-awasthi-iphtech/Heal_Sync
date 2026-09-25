//
//  AuthScreenConstants.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI

struct AuthScreenConstants {

    // Titles & subtitles per mode

    static let loginTitle = "Welcome Back"
    static let signupTitle = "Start Your Journey"
    static let loginSubtitle = "Sync your health data & stats"
    static let signupSubtitle = "Create an account to track your activity"

    // Form

    static let fullNamePlaceholder = "Full Name"
    static let emailPlaceholder = "Email Address"
    static let passwordPlaceholder = "Password"
    static let forgotPassword = "Forgot Password?"

    // Primary button

    static let loginButton = "Log In"
    static let signupButton = "Create Account"

    // Alert

    static let alertTitle = "Authentication Error"
    static let alertOK = "OK"

    // Validation & auth errors (AuthViewModel)

    static let noAccount = "No account found with this email."
    static let wrongPassword = "Incorrect password."
    static let accountExists = "An account with this email already exists."
    static let saveFailedPrefix = "Failed to save account: "
    static let nameRequired = "Please enter your full name."
    static let emailInvalid = "Please enter a valid email address."
    static let passwordTooShort = "Password must be at least 6 characters long."
    
    // Picker text
    
    static let select = "Select View"
}
