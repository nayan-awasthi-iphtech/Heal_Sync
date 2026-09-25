//
//  ActivityScreenConstants.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 25/09/26.
//

import SwiftUI

struct ActivityScreenConstants {
    
    // Title and Subtitle
    
    static let mainTitle = "Activity"
    static let subtitle = "Stay Active, Stay Healthy"
    
    // Picker Titles
    // NOTE: These double as logic keys (ActivityViewModel.selectedTab switch).
    // Keep values in sync with the view model if you localize them.
    
    static let day = "Day"
    static let week = "Week"
    static let month = "Month"
    
    // Progress Bar Text
    
    static let steps = "Steps"
    static let startTracking = "Start Tracking"
    static let stopTracking = "Stop"
    
    // Health Stats text
    
    static let km = "km"
    static let kcal = "kcal"
    static let min = "min"
    
    // Daypart Text
    
    static let morning = "Morning"
    static let evening = "Evening"
    static let afternoon = "Afternoon"
    static let night = "Night"
    
    // Bottom Activity card
    
    static let runImage = "figure.run"
    static let run = "Run"
    static let today = "Today"
    static let kmeter = "km"
    static let chevronRightImage = "chevron.right"
}
