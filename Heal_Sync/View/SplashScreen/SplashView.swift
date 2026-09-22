//
//  SplashView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 21/09/26.
//

import SwiftUI

enum Destination {
    case home
    case onboarding
    case auth
}

struct SplashView: View {
    
    @State private var logoOpacity: Double = 0.0
    @State private var logoScale: CGFloat = 0.8
    @State private var pulseGlow: Bool = false
    
    @State private var isActive: Bool = false
    @State private var targetDestination: Destination = .onboarding
    @StateObject private var sessionAuthViewModel = AuthViewModel()
    
    var body: some View {
        if isActive {
            switch targetDestination {
            case .home:
                if sessionAuthViewModel.isAuthenticated {
                    MainTabView()
                } else {
                    AuthView()
                }
            case .onboarding:
                LandingPage()
            case .auth:
                AuthView()
            }
        } else {
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.02, blue: 0.06),
                        Color(red: 0.06, green: 0.20, blue: 0.19)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Glow in the Center
                Circle()
                    .fill(Color(red: 0.30, green: 0.92, blue: 0.65).opacity(pulseGlow ? 0.22 : 0.08))
                    .frame(width: 250, height: 250)
                    .blur(radius: 60)
                    .scaleEffect(pulseGlow ? 1.2 : 0.9)
                
                // Brand Logo & Name
                VStack(spacing: 20) {
                    // App Logo Icon Container
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.12, green: 0.28, blue: 0.24),
                                        Color(red: 0.05, green: 0.18, blue: 0.16)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 96, height: 96)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.3), radius: 15)
                        
                        // Heart Pulse / Sync Icon
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 46, weight: .bold))
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                    }
                    
                    // App Title
                    HStack(spacing: 0) {
                        Text("Heal")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Sync")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                    }
                    
                    // Tagline
                    Text("Your Personal Health Companion")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
            }
            .onAppear {
                
                if SessionManager.shared.isLoggedIn {
                    targetDestination = .home
                } else if !SessionManager.shared.hasCompletedOnboarding {
                    targetDestination = .onboarding
                } else {
                    targetDestination = .auth
                }
                
                // Animation starts
                withAnimation(.easeOut(duration: 1.0)) {
                    logoOpacity = 1.0
                    logoScale = 1.0
                }
                
                // Soft Ambient Glow
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    pulseGlow = true
                }
                
                // Automatic Navigation Transition after 1.6 sec
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}


