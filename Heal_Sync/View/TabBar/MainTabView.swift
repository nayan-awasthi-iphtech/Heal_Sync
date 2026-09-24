//
//  MainTabView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct MainTabView: View {
    
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
                    Label("Home", systemImage: "house.fill")
                }
            
            ActivityScreenView()
                .tabItem {
                    Label("Activity", systemImage: "figure.run")
                }
            
            InsightsScreenView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct ProfileView: View {
    var body: some View {
        Text("profile Screen")
            .font(.system(size: 30))
    }
}

#Preview{
    MainTabView()
}
