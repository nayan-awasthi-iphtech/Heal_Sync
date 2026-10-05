//
//  ActivityScreenBottomCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ActivityScreenBottomCard: View {
    @EnvironmentObject var theme: ThemeManager
    var distanceKm: String = "0.0"
    var activityDate: Date = Date()

    // Daypart from the hour of the day
    private var daypart: String {
        let hour = Calendar.current.component(.hour, from: activityDate)
        switch hour {
        case 5..<12:
            return ActivityScreenConstants.morning
        case 12..<17:
            return ActivityScreenConstants.afternoon
        case 17..<22:
            return ActivityScreenConstants.evening
        default:
            return ActivityScreenConstants.night
        }
    }

    private var timeString: String {
        activityDate.formatted(date: .omitted, time: .shortened)
    }

    var body: some View {
        HStack(spacing:15){
            Image(systemName: ActivityScreenConstants.runImage)
                .resizable()
                .scaledToFit()
                .fontWeight(.heavy)
                .frame(width: 50, height: 50)
                .foregroundStyle(Color(red: 0.20, green: 0.69, blue: 0.67))

            VStack(alignment: .leading){
                Text("\(daypart) \(ActivityScreenConstants.run)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(theme.colors.primaryText)

                Text("\(ActivityScreenConstants.today), \(timeString)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(theme.colors.secondaryText)
            }

            Spacer()

            HStack(spacing: 3){
                Text(distanceKm)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(theme.colors.primaryText)
                    .contentTransition(.numericText())
                Text(ActivityScreenConstants.kmeter)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(theme.colors.secondaryText)
            }

            Image(systemName: ActivityScreenConstants.chevronRightImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(theme.colors.secondaryText)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.colors.cardBackground)
                .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal,15)
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
        ActivityScreenBottomCard()
            .environmentObject(ThemeManager())
    }
}
