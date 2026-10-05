//
//  HomeHeaderView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct HomeHeaderView: View {

    var onProfileTap: () -> Void = {}
    @EnvironmentObject var currentUser: CurrentUserViewModel
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Image(systemName: WelcomeScreenConstants.Images.heartFill)
                        .resizable()
                        .font(.title)
                        .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        .frame(width: 38, height: 34)

                    Image(systemName: WelcomeScreenConstants.Images.ecgWaveform)
                        .resizable()
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(width: 38, height: 18)
                }

                Text(WelcomeScreenConstants.appName)
                    .fontWeight(.bold)
                    .font(.system(size: 30, design: .default))
                    .foregroundStyle(theme.colors.primaryText)
            }
            Spacer()

            ZStack{
                Circle()
                    .fill(theme.isDarkMode ? .black.opacity(0.3) : .white)
                    .frame(width: 52, height: 52)
                    .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 4, x: 0, y: 2)

                Image(systemName: "bell")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(theme.colors.primaryText)
            }

            Button(action: onProfileTap) {
                Group {
                    if let img = currentUser.profileUIImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(theme.colors.secondaryText)
                    }
                }
                .frame(width: 52, height: 52)
                .background(
                    Circle()
                        .fill(theme.isDarkMode ? .black.opacity(0.3) : .white)
                )
                .clipShape(Circle())
                .padding(.horizontal, 2)
            }
            .accessibilityLabel("Open profile")
        }
    }
}

#Preview{

    ZStack{
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.02, blue: 0.06),
                Color(red: 0.06, green: 0.20, blue: 0.19)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()

        HomeHeaderView()
            .environmentObject(CurrentUserViewModel())
            .environmentObject(ThemeManager())
    }
}
