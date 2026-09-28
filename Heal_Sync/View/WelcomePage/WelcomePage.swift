//
//  WelcomePage.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 21/09/26.
//

import SwiftUI

struct WelcomePage: View {
    
    @State private var currentPage: Int = 0
    @State private var navigateToAuth: Bool = false
    
    var body: some View {
        ZStack {
            
            // MARK: - Base Background
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.02, blue: 0.1),
                    Color(red: 0.02, green: 0.15, blue: 0.17)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            // MARK: - Screen Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 35) {
                    
                    HeaderView()
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(WelcomeScreenConstants.priorityBadge)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color(red: 0.30, green: 0.85, blue: 0.65))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.08, green: 0.22, blue: 0.20).opacity(0.6))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color(red: 0.20, green: 0.45, blue: 0.38).opacity(0.5), lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading, spacing: -10) {
                            Text(WelcomeScreenConstants.morethanThinking)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                Text(WelcomeScreenConstants.A)
                                    .foregroundColor(.white)
                                
                                Text(WelcomeScreenConstants.healthier)
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            }
                            
                            Text(WelcomeScreenConstants.tomorrow)
                                .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        }
                        .font(.system(size: 39, weight: .bold, design: .default))
                        
                        VStack(alignment: .leading, spacing: 14){
                            VStack(alignment: .leading, spacing: 4){
                                Text(WelcomeScreenConstants.description)
                                    .font(.system(size: 21))
                                    .foregroundStyle(.white).opacity(0.7)
                            }
                            
                            WelcomeCard(
                                imageName: "chart.bar.fill",
                                titleText: WelcomeScreenConstants.Card1.title,
                                descriptionText: WelcomeScreenConstants.Card1.des
                            )
                            
                            WelcomeCard(
                                imageName: "heart.fill",
                                titleText: WelcomeScreenConstants.Card2.title,
                                descriptionText: WelcomeScreenConstants.Card2.des
                            )
                            
                            WelcomeCard(
                                imageName: "person.badge.plus",
                                titleText: WelcomeScreenConstants.Card3.title,
                                descriptionText: WelcomeScreenConstants.Card3.des
                            )
                            
                            Button(action: {
                                SessionManager.shared.hasCompletedOnboarding = true
                                navigateToAuth = true
                            }) {
                                HStack(spacing: 8) {
                                    Text(WelcomeScreenConstants.getStarted)
                                        .font(.system(size: 20, weight: .semibold))
                                    
                                    Image(systemName: WelcomeScreenConstants.Images.arrowRight)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationDestination(isPresented: $navigateToAuth) {
            AuthView()
        }
    }
}

#Preview {
    WelcomePage()
}
