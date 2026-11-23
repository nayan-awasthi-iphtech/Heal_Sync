//
//  ProfileScreenConstants.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI

struct ProfileScreenConstants {

    // Header

    static let mainTitle = "Profile"
    static let subtitle = "Manage Your Account"

    // Today banner

    static let todayBadge = "Today"

    // Range subtitles

    static let daySubtitle = "Today's activity"
    static let weekSubtitle = "This week's activity"
    static let monthSubtitle = "This month's activity"

    // Stat cards

    static let steps = "Steps"
    static let calories = "Calories"
    static let distance = "Distance"
    static let activeTime = "Active Time"
    static let totalBadge = "Total"
    static let activeBadge = "Active"
    static let heartRate = "Heart Rate"
    static let sleep = "Sleep"
    static let bpmUnit = "bpm"

    // User card

    static let memberSinceFormat = "Member since %@"
    static let unknownUser = "—"

    // Logout

    static let logout = "Log Out"
    static let logoutTitle = "Log Out?"
    static let logoutMessage = "Are you sure you want to log out of HealSync?"
    static let logoutConfirm = "Log Out"
    static let logoutCancel = "Cancel"
    
    // Edit profile

    static let editProfile = "Edit Profile"
    static let namePlaceholder = "Full Name"
    static let nameRequired = "Name is required"
    static let nameTooShort = "Name must be at least 2 characters"
    static let nameTooLong = "Name must be 50 characters or fewer"
    static let save = "Save"
    static let cancel = "Cancel"

    static let bodyMetricsTitle = "Body Metrics"
    static let height = "Height"
    static let weight = "Weight"
    static let bmi = "BMI"
    static let cmUnit = "cm"
    static let kgUnit = "kg"
    static let notSet = "—"
    static let heightPlaceholder = "Height (cm)"
    static let weightPlaceholder = "Weight (kg)"
    static let bodyHint = "Add your height & weight for better BMI and insights."
    static let bodyAlertTitle = "Complete Your Profile"
    static let bodyAlertMessage = "Please add your height & weight for better BMI and insights."
    static let bodyAlertOK = "OK"
    static let editBodyMetrics = "Edit"
    static let bmiUnderweight = "Underweight"
    static let bmiHealthy = "Healthy"
    static let bmiOverweight = "Overweight"
    static let bmiObese = "Obese"
    static let bmiHealthyRange = "18.5 – 24.9 healthy"

    // Highlights (same card UI, existing stores only)

    static let highlightsTitle = "Highlights"
    static let bestDay = "Best Day"
    static let activeDays = "Active Days"
    static let monthDistance = "30-Day Distance"
    static let dayStreak = "Day Streak"
    static let daysUnit = "days"
    static let dayUnit = "day"
    static let stepsUnit = "steps"

    // Wellness week removed — kept last7Days (used by Highlights Active Days)
    static let last7Days = "Last 7 days"
}
