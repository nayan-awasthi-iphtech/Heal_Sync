//
//  HomeScreenConstants.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import Foundation

struct HomeScreenConstants {
    
    struct Greetings {
        static let goodMorning = "Good Morning,"
        static let fallbackName = "Friend"
        static let subtitle = "Your Health Journey matters!"
    }
    
    struct Banner {
        static let stayHealthyTag = "STAY HEALTHY"
        static let headlinePart1 = "A Better"
        static let headlinePart2 = "You Today"
        static let tagline = "Track, Improve, Live Better."
        static let buttonTitle = "Explore Your Health"
    }
    
    struct Overview {
        static let sectionTitle = "Today's Overview"
        static let seeAll = "See All"
    }
    
    // Today's stat cards (values with numbers stay inline in the view)
    struct Stats {
        static let steps = "Steps"
        static let heartRate = "Heart Rate"
        static let calories = "Calories"
        static let sleep = "Sleep"
        
        static let normalBadge = "Normal"
        static let goodBadge = "Good"
        
        static let bpmUnit = "bpm"
        static let kcalUnit = "kcal"
    }
    
    struct Icons {
        static let greetingEmoji = "hands.clap"
        static let ecgWaveform = "waveform.path.ecg"
    }
    
    static let quick = "Quick Actions"
    
    struct BottomCardIcons {
        static let logIcon = "figure.run"
        static let ForkIcon = "fork.knife"
        static let HeartIcon = "heart.fill"
        static let TargetIcon = "target"
    }
    
    struct TitleText {
        static let LogText = "Log\nActivity"
        static let ForkText = "Track\nNutrition"
        static let VitalText = "Check\nVital"
        static let TargetText = "Set\nGoals"
    }
}
