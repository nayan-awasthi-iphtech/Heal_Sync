//
//  HomeScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct HomeScreenView: View {
    
    // Live today tracker shared from MainTabView
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var currentUser: CurrentUserViewModel
    @EnvironmentObject var theme: ThemeManager
    var onProfileTap: () -> Void = {}
    var onHealthTap: () -> Void = {}
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour{
        case 5..<12:
            return HomeScreenConstants.Greetings.goodMorning
        case 12..<17:
            return HomeScreenConstants.Greetings.goodAfternoon
        case 17..<21:
            return HomeScreenConstants.Greetings.goodEvening
        default:
            return HomeScreenConstants.Greetings.goodNight
        }
    }
        
        var body: some View {
            ZStack {
                ThemedBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        HomeHeaderView(onProfileTap: onProfileTap)
                        
                        VStack(alignment: .leading) {
                            Text(greetingText)
                                .font(.system(size: 17))
                                .foregroundStyle(theme.colors.secondaryText)
                            
                            HStack(alignment: .center, spacing: 15) {
                                Text(currentUser.firstName)
                                    .font(.system(size: 28))
                                    .foregroundStyle(theme.colors.primaryText)
                                
                                Image(systemName: HomeScreenConstants.Icons.greetingEmoji)
                                    .font(.system(size: 28))
                                    .foregroundStyle(.yellow)
                                    .offset(y: -4)
                            }
                            
                            Text(HomeScreenConstants.Greetings.subtitle)
                                .font(.system(size: 17))
                                .foregroundStyle(theme.colors.secondaryText)
                        }
                        
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(HomeScreenConstants.Banner.stayHealthyTag)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Color(red: 0.20, green: 0.77, blue: 0.60))
                                
                                Text(HomeScreenConstants.Banner.headlinePart1)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(theme.colors.primaryText)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                Text(HomeScreenConstants.Banner.headlinePart2)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(Color(red: 0.20, green: 0.77, blue: 0.60))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                
                                Text(HomeScreenConstants.Banner.tagline)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(theme.colors.secondaryText)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.85)
                                
                                Button(action: {
                                    onHealthTap()
                                }) {
                                    HStack(spacing: 6) {
                                        Text(HomeScreenConstants.Banner.buttonTitle)
                                            .font(.system(size: 13, weight: .semibold))
                                        
                                        Image(systemName: WelcomeScreenConstants.Images.arrowRight)
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(
                                        Capsule()
                                            .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                                    )
                                }
                                .padding(.top, 4)
                            }
                            .layoutPriority(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ZStack {
                                // Outer Glow Ring
                                Circle()
                                    .fill(Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.15))
                                    .frame(width: 110, height: 110)
                                    .blur(radius: 10)
                                
                                // Dark Background Circle with Gradient Border
                                Circle()
                                    .fill(
                                        theme.isDarkMode ?
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.08, green: 0.22, blue: 0.20),
                                                Color(red: 0.04, green: 0.10, blue: 0.12)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ) :
                                            LinearGradient(
                                                colors: [
                                                    Color.white,
                                                    Color(red: 0.88, green: 0.94, blue: 0.92)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                    )
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.30, green: 0.92, blue: 0.65),
                                                        Color.white.opacity(0.1)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    )
                                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                // App Symbol (Heart & Sync Indicator)
                                Image(systemName: HomeScreenConstants.Icons.ecgWaveform)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            }
                            .frame(width: 110, height: 130)
                            .rotation3DEffect(.degrees(-15), axis: (x: 1, y: 0, z: 0))
                            .rotation3DEffect(.degrees(-20), axis: (x: 0, y: 1, z: 0))
                            .rotation3DEffect(.degrees(35), axis: (x: 0, y: 0, z: 1))
                        }
                        .padding(22)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(theme.colors.cardBackground)
                                .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
                        )
                        
                        HStack(spacing: 12) {
                            Text(HomeScreenConstants.Overview.sectionTitle)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(theme.colors.primaryText)
                            
                            Spacer()
                            
                            HStack {
                                Text(HomeScreenConstants.Overview.seeAll)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Color(red: 0.20, green: 0.77, blue: 0.60))
                                
                                Image(systemName: WelcomeScreenConstants.Images.arrowRight)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Color(red: 0.20, green: 0.77, blue: 0.60))
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            // Steps Card (live today count)
                            HomeScreenOverviewCard1(
                                imageName: "figure.run",
                                titleText: HomeScreenConstants.Stats.steps,
                                descriptionText: activityViewModel.todayStepsFormatted,
                                goalText: "/\(ActivityViewModel.dayStepGoal.formatted())",
                                progress: activityViewModel.todayStepsProgress
                            )
                            
                            // Heart Rate Card
                            HomeScreenOverviewCard2(
                                imageName: "heart.fill",
                                titleText: HomeScreenConstants.Stats.heartRate,
                                descriptionText: "72 \(HomeScreenConstants.Stats.bpmUnit)",
                                resultText: HomeScreenConstants.Stats.normalBadge,
                                imageColor: Color.red
                            )
                        }
                        
                        HStack(alignment: .top, spacing: 10) {
                            // Calories Card (live today count)
                            HomeScreenOverviewCard1(
                                imageName: "flame.fill",
                                titleText: HomeScreenConstants.Stats.calories,
                                descriptionText: activityViewModel.todayCaloriesFormatted,
                                goalText: "of \(ActivityViewModel.dayCalorieGoal.formatted()) \(HomeScreenConstants.Stats.kcalUnit)",
                                progress: activityViewModel.todayCaloriesProgress,
                                progressColor: Color.orange,
                                imageColor: Color.red
                            )
                            
                            // Sleep Card
                            HomeScreenOverviewCard2(
                                imageName: "moon.stars.fill",
                                titleText: HomeScreenConstants.Stats.sleep,
                                descriptionText: "7 h 20 m",
                                resultText: HomeScreenConstants.Stats.goodBadge,
                                imageColor: Color.purple
                            )
                        }
                        
                        Text(HomeScreenConstants.quick)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(theme.colors.primaryText)
                        
                        HStack(spacing: 10){
                            HomeBottomCard(
                                imageName: HomeScreenConstants.BottomCardIcons.logIcon,
                                titleText: HomeScreenConstants.TitleText.LogText,
                                imageColor: .green,
                                customGlowColor: .green,
                            )
                            
                            HomeBottomCard(
                                imageName: HomeScreenConstants.BottomCardIcons.ForkIcon,
                                titleText: HomeScreenConstants.TitleText.ForkText,
                                imageColor: .blue,
                                customGlowColor: .blue,
                            )
                            
                            HomeBottomCard(
                                imageName: HomeScreenConstants.BottomCardIcons.HeartIcon,
                                titleText: HomeScreenConstants.TitleText.VitalText,
                                imageColor: .red,
                                customGlowColor: .red
                            )
                            
                            HomeBottomCard(
                                imageName: HomeScreenConstants.BottomCardIcons.TargetIcon,
                                titleText: HomeScreenConstants.TitleText.TargetText,
                                imageColor: .purple,
                                customGlowColor: .purple,
                            )
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                .onAppear{
                    print("Name of the user:", currentUser.displayName)
                }
            }
        }
    }
    
    #Preview {
        HomeScreenView()
            .environmentObject(ActivityViewModel())
            .environmentObject(CurrentUserViewModel())
            .environmentObject(ThemeManager())
    }
