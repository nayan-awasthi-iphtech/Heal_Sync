//
//  ActivityScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

enum DayDuration: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
}

struct ActivityData {
    let currentSteps: Int
    let targetGoal: Int
}

struct ActivityScreenView: View {
    
    @State private var duration: DayDuration = .day
    
    init() {
        let appearance = UISegmentedControl.appearance()
        
        // Background color of the segmented picker container
        appearance.backgroundColor = UIColor(red: 0.07, green: 0.14, blue: 0.16, alpha: 1.0)
        
        // Selected segment color (light green)
        appearance.selectedSegmentTintColor = UIColor(red: 0.20, green: 0.69, blue: 0.67, alpha: 1.0)
        
        // Custom font size
        appearance.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13, weight: .bold)
        ], for: .normal)
        
        appearance.setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 13, weight: .bold)
        ], for: .selected)
    }
    
    private var activityData: ActivityData {
        switch duration {
        case .day:
            return ActivityData(currentSteps: 7482, targetGoal: 10000)
        case .week:
            return ActivityData(currentSteps: 52300, targetGoal: 70000)
        case .month:
            return ActivityData(currentSteps: 210500, targetGoal: 300000)
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
                VStack(alignment: .leading, spacing: 8){
                    Text("Actvity")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Stay Active, Stay Healthy")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Picker("Duration", selection: $duration){
                    ForEach(DayDuration.allCases, id: \.self){ days in
                        Text(days.rawValue).tag(days)
                    }
                }
                .pickerStyle(.segmented)
                .scaleEffect(y: 1.5)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                
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
