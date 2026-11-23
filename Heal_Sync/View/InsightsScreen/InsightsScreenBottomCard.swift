//
//  InsightsScreenBottomCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct InsightsScreenBottomCard: View {
    @EnvironmentObject var theme: ThemeManager
    var title: String = InsightsScreenConstants.keepItUp
    var message: String = InsightsScreenConstants.healthyRange
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: InsightsScreenConstants.Images.bulb)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.yellow)
                .padding(12)
                .background(
                    Capsule()
                        .fill(Color.yellow.opacity(0.2))
                        .blur(radius: 10)
                )

            VStack(alignment: .leading, spacing: 5){
                Text(title)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(theme.colors.primaryText)

                Text(message)
                    .font(.system(size: 16))
                    .foregroundStyle(theme.colors.secondaryText)

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 17)
                .fill(theme.colors.cardBackground)
                .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
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
        InsightsScreenBottomCard()
            .environmentObject(ThemeManager())
    }
}
