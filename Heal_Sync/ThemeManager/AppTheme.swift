//
//  AppTheme.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 30/09/26.
//

import SwiftUI
import Combine

final class ThemeManager: ObservableObject {
    @AppStorage("healsync_is_dark_mode") var isDarkMode: Bool = true {
        willSet { objectWillChange.send() }
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }

    var colors: AppColors {
        isDarkMode ? .dark : .light
    }

    func toggle() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            isDarkMode.toggle()
        }
    }
}

struct AppColors {
    let backgroundTop: Color
    let backgroundBottom: Color
    let cardBackground: Color
    let primaryText: Color
    let secondaryText: Color
    let placeholderText: Color
    let accent: Color

    var backgroundGradientColors: [Color] {
        [backgroundTop, backgroundBottom]
    }

    static let dark = AppColors(
        backgroundTop: Color(red: 0.04, green: 0.02, blue: 0.10),
        backgroundBottom: Color(red: 0.02, green: 0.15, blue: 0.17),
        cardBackground: Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85),
        primaryText: .white,
        secondaryText: .white.opacity(0.70),
        placeholderText: .white.opacity(0.40),
        accent: Color(red: 0.30, green: 0.92, blue: 0.65)
    )

    static let light = AppColors(
        backgroundTop: Color(red: 0.96, green: 0.98, blue: 0.97),
        backgroundBottom: Color(red: 0.88, green: 0.94, blue: 0.92),
        cardBackground: .white,
        primaryText: Color(red: 0.04, green: 0.10, blue: 0.11),
        secondaryText: Color(red: 0.04, green: 0.10, blue: 0.11).opacity(0.65),
        placeholderText: Color(red: 0.04, green: 0.10, blue: 0.11).opacity(0.40),
        accent: Color(red: 0.20, green: 0.69, blue: 0.67)
    )
}

struct ThemedBackground: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        LinearGradient(
            colors: theme.colors.backgroundGradientColors,
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
    }
}
