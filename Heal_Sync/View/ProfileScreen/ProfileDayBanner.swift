//
//  ProfileDayBanner.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct ProfileDayBanner: View {

    var todayTitle: String

    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(mintGreen)

            Text(todayTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

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
                .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
