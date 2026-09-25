//
//  Heal_SyncApp.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 18/09/26.
//

import SwiftUI
import CoreData

@main
struct Heal_SyncApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authViewModel)
        }
    }
}

// Separate Root Controller to manage app transitions smoothly
struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSplash: Bool = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                    }
                }
            } else {
                // Dynamic switching based on authentication state!
                if authViewModel.isAuthenticated {
                    MainTabView()
                } else if !SessionManager.shared.hasCompletedOnboarding {
                    LandingPage()
                } else {
                    AuthView()
                }
            }
        }
    }
}
