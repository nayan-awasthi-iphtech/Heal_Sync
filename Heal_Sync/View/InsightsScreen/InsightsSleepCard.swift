//
//  InsightsSleepCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import SwiftUI

struct InsightsSleepCard: View {

    private let sleepPurple = Color(red: 0.68, green: 0.55, blue: 1.0)
    private let darkTeal = Color(red: 0.07, green: 0.14, blue: 0.16)
    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack(spacing: 8) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(sleepPurple)

                Text(InsightsScreenConstants.sleepTitle)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: InsightsScreenConstants.Images.chevronRight)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }

            // Value row
            HStack(alignment: .bottom, spacing: 12) {
                Text(InsightsScreenConstants.sleepValue)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Text(InsightsScreenConstants.sleepBadge)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(mintGreen)
                    )
                    .padding(.bottom, 6)
            }

            // Simple goal progress (7h20m of 8h)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.12))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [sleepPurple, sleepPurple.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * 0.92))
                        .shadow(color: sleepPurple.opacity(0.6), radius: 6, x: 0, y: 0)
                }
            }
            .frame(height: 8)

            Text("92% \(InsightsScreenConstants.sleepGoalLabel)")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.7))

            // Bedtime / Wake split
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "bed.double.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(sleepPurple)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(InsightsScreenConstants.bedtimeTitle)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                        Text(InsightsScreenConstants.bedtimeValue)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.06))
                )

                HStack(spacing: 8) {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(InsightsScreenConstants.wakeTitle)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                        Text(InsightsScreenConstants.wakeValue)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.06))
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(darkTeal.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
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
        InsightsSleepCard()
    }
}
