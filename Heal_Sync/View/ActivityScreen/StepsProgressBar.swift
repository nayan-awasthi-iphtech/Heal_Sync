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

    var isTracking: Bool = false
    var onToggleTracking: () -> Void = {}

    private var progress: CGFloat {
        guard goalSteps > 0 else { return 0 }
        return min(CGFloat(currentSteps) / CGFloat(goalSteps), 1.0)
    }

    private let primaryGreen = Color(red: 0.20, green: 0.69, blue: 0.67)
    private let trackColor = Color(red: 0.08, green: 0.16, blue: 0.18)

    private var trackingButton: some View {
        Button(action: onToggleTracking) {
            Image(systemName: isTracking ? ActivityScreenConstants.Symbols.pause : ActivityScreenConstants.Symbols.play)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(isTracking ? .blue.opacity(0.5) : .black.opacity(0.5))
                .frame(width: 69, height: 69)
                .background(
                    Circle()
                        .fill(isTracking ? Color.blue.opacity(0.0) : Color(red: 0.30, green: 0.92, blue: 0.85).opacity(0.35))
                )
                .overlay(Circle().stroke(Color.white.opacity(0.35), lineWidth: 1.5))
                .shadow(color: .black, radius: 8, x: 0, y: 14)
        }
        .accessibilityLabel(isTracking ? ActivityScreenConstants.Symbols.stop : ActivityScreenConstants.Symbols.start)
        .offset(x: 58, y: -15)
    }

    var body: some View {
        ZStack {
            // Circular Progress Rings
            Circle()
                .stroke(trackColor, lineWidth: 16)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(primaryGreen, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)

            // Content
            VStack(spacing: 6) {
                Image(systemName: ActivityScreenConstants.Symbols.shoeImage)
                    .font(.system(size: 34))
                    .foregroundColor(primaryGreen)
                    .rotationEffect(.degrees(40))

                Text(currentSteps.formatted())
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())

                Text(ActivityScreenConstants.steps)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))

                Text("/ \(goalSteps.formatted())")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(primaryGreen)
                    .contentTransition(.numericText())
            }
        }
        .frame(width: 230, height: 250)
        .overlay(alignment: .bottom) {
            trackingButton.offset(y: 28)
        }
        .padding(20)
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
        StepProgressCard(currentSteps: 7000, goalSteps: 10000)
    }
}


