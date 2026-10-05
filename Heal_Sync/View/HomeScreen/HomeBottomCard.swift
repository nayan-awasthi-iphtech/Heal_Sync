//
//  HomeBottomCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct HomeBottomCard: View {

    @EnvironmentObject var theme: ThemeManager
    let imageName: String
    let titleText: String

    var imageColor: Color = Color(red: 0.30, green: 0.92, blue: 0.65)
    var backgroundColor: Color? = nil
    var customGlowColor: Color? = nil

    private var glowColor: Color {
        customGlowColor ?? imageColor
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: imageName)
                .font(.system(size: 25))
                .foregroundColor(imageColor)
                .frame(width: 22, height: 22)
                .padding(.top, 1)
                .background(
                    RadialGradient(
                        colors: [
                            glowColor.opacity(0.18),
                            glowColor.opacity(0)
                        ],
                        center: .center,
                        startRadius: 2,
                        endRadius: 30
                    )
                    .frame(width: 50, height: 50)
                )

            Text(titleText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(theme.colors.primaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.85)
        }
        .padding(12)
        .frame(maxWidth: 80, minHeight: 92, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColor ?? theme.colors.cardBackground)
                .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    HomeBottomCard(
        imageName: "figure.run",
        titleText: "Log\nActivity",
    )
    .environmentObject(ThemeManager())
}
