//
//  ProfileBMICard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct ProfileBMICard: View {

    @ObservedObject var currentUser: CurrentUserViewModel

    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(mintGreen)

                Text(ProfileScreenConstants.bmi)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Text(currentUser.bmiFormatted)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }

            HStack(spacing: 8) {
                Text(currentUser.bmiCategory)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(currentUser.bmiCategoryColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(currentUser.bmiCategoryColor.opacity(0.15))
                            .overlay(
                                Capsule()
                                    .stroke(currentUser.bmiCategoryColor.opacity(0.4), lineWidth: 1)
                            )
                    )

                Text(ProfileScreenConstants.bmiHealthyRange)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.55))

                Spacer()
            }

            GeometryReader { geo in
                let clamped = min(max(currentUser.bmiValue > 0 ? currentUser.bmiValue : 16, 14), 34)
                let progress = (clamped - 14) / 20.0
                ZStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Rectangle().fill(Color.blue.opacity(0.7))
                        Rectangle().fill(Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.85))
                        Rectangle().fill(Color.orange.opacity(0.85))
                        Rectangle().fill(Color.red.opacity(0.85))
                    }
                    .frame(height: 8)
                    .clipShape(Capsule())
                    .opacity(currentUser.bmiValue > 0 ? 1.0 : 0.25)

                    Circle()
                        .fill(.white)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(currentUser.bmiCategoryColor, lineWidth: 3))
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 1)
                        .offset(x: max(0, min(progress * (geo.size.width - 14), geo.size.width - 14)))
                        .opacity(currentUser.bmiValue > 0 ? 1.0 : 0.0)
                }
            }
            .frame(height: 14)
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
