//
//  ActivityScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ActivityData {
    let currentSteps: Int
    let targetGoal: Int
}

struct ActivityScreenView: View {
    
    @State private var selectedTab: String = "Day"
    let options = ["Day", "Week", "Month"]
    
    private var activityData: ActivityData {
        switch selectedTab {
        case "Day":
            return ActivityData(currentSteps: 7482, targetGoal: 10000)
        case "Week":
            return ActivityData(currentSteps: 52300, targetGoal: 70000)
        case "Month":
            return ActivityData(currentSteps: 210500, targetGoal: 300000)
        default:
            return ActivityData(currentSteps: 7482, targetGoal: 10000)
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.02, blue: 0.06),
                    Color(red: 0.06, green: 0.10, blue: 0.09)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false){
                HeaderView(title: "Activity", subTitle: "Stay Active, Stay Healthy")
                
                PickerView(
                    selection: $selectedTab,
                    options: options
                )
                
                StepProgressCard(currentSteps: activityData.currentSteps, goalSteps: activityData.targetGoal)
                
                VStack(spacing: 25){
                    HStack(spacing: 100){
                        ActivityScreenComponent(ImageName: "mapSymbol",titleText: "5.2", unitText: "km")
                        ActivityScreenComponent(ImageName: "flame", isSystemImage: true, titleText: "320", unitText: "kcal", ImageColor: .red)
                        ActivityScreenComponent(ImageName: "stopwatch", isSystemImage: true, titleText: "48", unitText: "min")
                    }
                    
                    ActivityScreenBottomCard()
                }
            }
        }
    }
}

#Preview {
    ActivityScreenView()
}
