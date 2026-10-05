//
//  ProfileDayBanner.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct ProfileDayBanner: View {

    @EnvironmentObject var theme: ThemeManager
    var todayTitle: String

    private var mintGreen: Color { theme.colors.accent }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(mintGreen)

            Text(todayTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(theme.colors.primaryText)

            Spacer()

            Text(ProfileScreenConstants.todayBadge)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(mintGreen)
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.colors.cardBackground)
                .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
