//
//  MainTabView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct MainTabView: View {
    
    /// Single shared activity tracker: Home (live today cards) and Activity
    /// (Day/Week/Month) observe the same instance, so there is exactly one
    /// pedometer stream and one source of truth.
    @StateObject private var activityViewModel = ActivityViewModel()
    
    init() {
        // Sets up dark background for the TabBar to match your theme
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.02, green: 0.09, blue: 0.04, alpha: 0.95)
        
        // Sets unselected tab item icon and text colors
        appearance.compactInlineLayoutAppearance.normal.iconColor = .lightGray
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            HomeScreenView()
                .tabItem {
                    Label(TabBarConstants.home, systemImage: "house.fill")
                }
            
            ActivityScreenView()
                .tabItem {
                    Label(TabBarConstants.activity, systemImage: "figure.run")
                }
            
            InsightsScreenView()
                .tabItem {
                    Label(TabBarConstants.health, systemImage: "heart.fill")
                }
            
            ProfileScreenView()
                .tabItem {
                    Label(TabBarConstants.profile, systemImage: "person.fill")
                }
        }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(activityViewModel)
        .onAppear {
            activityViewModel.onAppear()
        }
        .onDisappear {
            activityViewModel.onDisappear()
        }
    }
}

#Preview{
    MainTabView()
        .environmentObject(AuthViewModel())
}
