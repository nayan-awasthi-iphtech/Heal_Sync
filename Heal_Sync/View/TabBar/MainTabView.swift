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
            
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "figure.run")
                }
            
            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(Color(red: 0.30, green: 0.92, blue: 0.65))
    }
}

// Placeholder tabs
struct ActivityView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Activity")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

struct HealthView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Health")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Profile")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                
                Button("Log Out") {
                    SessionManager.shared.clearSession()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.30, green: 0.92, blue: 0.65))
            }
        }
    }
}

#Preview {
    MainTabView()
}
