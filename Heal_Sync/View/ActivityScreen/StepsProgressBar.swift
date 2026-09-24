//
//  StepsProgressBar.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct StepProgressCard: View {
    let currentSteps: Int
    let goalSteps: Int
    
    // Calculates percentage completion
    private var progress: CGFloat {
        guard goalSteps > 0 else { return 0 }
        return min(CGFloat(currentSteps) / CGFloat(goalSteps), 1.0)
    }
    
    private let primaryGreen = Color(red: 0.20, green: 0.69, blue: 0.67)
    private let trackColor = Color(red: 0.08, green: 0.16, blue: 0.18)
    
    var body: some View {
        ZStack {
            // Background & Active Rings
            ZStack {
                Circle()
                    .stroke(trackColor, lineWidth: 16)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        primaryGreen,
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
            }
            .frame(width: 230, height: 250)
            
            // Text Details
            VStack(spacing: 10) {
                Image(systemName: "shoe.fill")
                    .font(.system(size: 34))
                    .foregroundColor(primaryGreen)
                    .rotationEffect(.degrees(40))
                    .padding(.bottom, 2)
                
                Text(currentSteps.formatted())
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
                    .padding(.top,4)
                
                Text("Steps")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("/ \(goalSteps.formatted())")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(primaryGreen)
                    .contentTransition(.numericText())
            }
        }
        .padding(20)
    }
}

#Preview {
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
        StepProgressCard(currentSteps: 7000, goalSteps: 10000)
    }
}
