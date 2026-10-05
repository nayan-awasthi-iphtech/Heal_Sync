//
//  ProfileHeaderView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct ProfileHeaderView: View {

    @EnvironmentObject var theme: ThemeManager
    var onEditTap: () -> Void

    private var mintGreen: Color { theme.colors.accent }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            HeaderView(title: ProfileScreenConstants.mainTitle, subTitle: ProfileScreenConstants.subtitle)

            Button {
                theme.toggle()
            } label: {
                Image(systemName: theme.isDarkMode ? "moon.fill" : "sun.max.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(theme.isDarkMode ? .black : Color(red: 1.0, green: 0.80, blue: 0.25))
                    .contentTransition(.symbolEffect(.replace))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(theme.isDarkMode ? mintGreen : Color(red: 0.12, green: 0.14, blue: 0.20))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: (theme.isDarkMode ? mintGreen : Color(red: 1.0, green: 0.80, blue: 0.25)).opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .accessibilityLabel(theme.isDarkMode ? "Switch to light mode" : "Switch to dark mode")
            .padding(.top, 22)
            .padding(.trailing, 10)

            Button(action: onEditTap) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .padding(.top, 22)
            .padding(.trailing, 16)
        }
    }
}
