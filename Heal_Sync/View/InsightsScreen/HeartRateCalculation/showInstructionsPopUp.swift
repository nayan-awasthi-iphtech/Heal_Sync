//
//  showInstructionsPopUp.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import SwiftUI

struct InstructionPopupCard: View {
    @EnvironmentObject var theme: ThemeManager
    var onStart: () -> Void
    var onCancel: () -> Void

    private var mintGreen: Color { theme.colors.accent }
    private var cardBackground: Color { theme.colors.cardBackground }

    var body: some View {
        ZStack {
            // Dimmed backdrop
            Color.black.opacity(0.65)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            // Popup Card
            VStack(spacing: 18) {
                // Header Icon
                ZStack {
                    Circle()
                        .fill(mintGreen.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: "hand.point.up.fill")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(mintGreen)
                }
                .padding(.top, 6)

                // Text Content
                VStack(spacing: 8) {
                    Text(ShowInstructionsPopUpConstants.measureTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(theme.colors.primaryText)

                    Text(ShowInstructionsPopUpConstants.instructionsText)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(theme.colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)

                    Text(InsightsScreenConstants.fitnessDisclaimer)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(theme.colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 8)

                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: onCancel) {
                        Text(ShowInstructionsPopUpConstants.cancel)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(theme.colors.secondaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                            .cornerRadius(10)
                    }

                    Button(action: onStart) {
                        Text(ShowInstructionsPopUpConstants.startScan)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(mintGreen)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 4)
            }
            .padding(20)
            .frame(width: 300)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardBackground)
                    .shadow(color: theme.isDarkMode ? .black.opacity(0.4) : .black.opacity(0.12), radius: 20, x: 0, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(theme.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

#Preview {
    InstructionPopupCard(onStart: {}, onCancel: {})
        .environmentObject(ThemeManager())
}
