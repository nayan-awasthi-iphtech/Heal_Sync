//
//  InsightsScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct InsightsScreenView: View {
    
    @StateObject private var heartRateManager = HeartRateManager()
    @EnvironmentObject var activityVM: ActivityViewModel
    
    @State private var showInstructionsPopup: Bool = false
    
    @State private var selectedTab: String = InsightsScreenConstants.health
    let options = [
        InsightsScreenConstants.health,
        InsightsScreenConstants.sleep,
        InsightsScreenConstants.calories
    ]
    
    var body: some View {
        
        ZStack{
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.07),
                    Color(red: 0.04, green: 0.10, blue: 0.07)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    
                    HeaderView(title: InsightsScreenConstants.mainTitle, subTitle: InsightsScreenConstants.subtitle)
                    
                    PickerView(selection: $selectedTab, options: options)
                    
                    if selectedTab == InsightsScreenConstants.calories {
                        InsightsCaloriesCard()
                            .padding(.top, 8)
                    } else if selectedTab == InsightsScreenConstants.health {
                        InsightsScreenCenterCard(liveBPM: heartRateManager.currentBPM)
                            .padding(.top, 8)
                    } else {
                        InsightsSleepCard()
                            .padding(.top, 8)
                    }
                    
                    if selectedTab == InsightsScreenConstants.health {
                        Button(action: {
                            heartRateManager.startMeasurement()
                        }) {
                            HStack {
                                Image(systemName: "hand.point.up.fill")
                                Text("Start Pulse Scan")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.30, green: 0.92, blue: 0.65)) // mintGreen
                            .cornerRadius(14)
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 8)
                    }
                    
                    if selectedTab == InsightsScreenConstants.calories {
                        InsightsScreenBottomCard(
                            title: InsightsScreenConstants.caloriesKeepItUp,
                            message: calorieInsightMessage
                        )
                        .padding(.top, 10)
                    } else {
                        InsightsScreenBottomCard()
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
            }
        }
        .overlay(
            Group {
                if showInstructionsPopup {
                    InstructionPopupCard (
                        onStart: {
                            withAnimation{ showInstructionsPopup = true }
                            heartRateManager.startMeasurement()
                        },
                        onCancel: {
                            withAnimation{ showInstructionsPopup = false }
                        }
                    )
                }
            }
        )
    }

    private var calorieInsightMessage: String {
        let today = activityVM.todayCaloriesValue
        let goal = ActivityViewModel.dayCalorieGoal
        if today <= 0 {
            return "No calories burned yet today. Start tracking to see progress."
        } else if today >= goal {
            return "Goal reached — \(today) of \(goal) kcal burned today."
        } else {
            return "\(today) of \(goal) kcal — keep moving to hit your goal."
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.02, blue: 0.06),
                Color(red: 0.06, green: 0.10, blue: 0.09)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
        InsightsScreenView()
            .environmentObject(ActivityViewModel())
    }
}
