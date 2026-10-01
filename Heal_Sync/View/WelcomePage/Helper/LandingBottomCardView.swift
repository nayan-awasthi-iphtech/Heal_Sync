//
//  LandingBottomCardView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 01/10/26.
//

import SwiftUI

struct LandingBottomCardView: View {
    
    @EnvironmentObject var theme: ThemeManager
    var currentPage: Int = 0
    let rightImg: String
    let leftSymbol: String
    let titleText1: String
    let titleText2: String
    let descriptionText: String
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 42) {
                // Left side: Runner image
                Image(rightImg)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 195)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
                
                // Right side: Text content + Green Heart Icon
                VStack(alignment: .leading, spacing: 8) {
                    
                    // Header line: Green Heart Badge + "Track"
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: leftSymbol)
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            .shadow(color: Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.5), radius: 10)
                        
                        Text(titleText1)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(theme.colors.primaryText)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    }
                    
                    // "Daily Activity" on next line
                    Text(titleText2)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(theme.colors.primaryText)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    
                    // Description
                    Text(descriptionText)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(theme.colors.secondaryText)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 2)
                }
                .layoutPriority(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 230)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(theme.colors.cardBackground)
                    .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(theme.isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.08), lineWidth: 1)
            )
        }
    }
}

#Preview {
    LandingBottomCardView(rightImg: LandingScreenConstants.Images.runningImage, leftSymbol: LandingScreenConstants.Images.heartFill, titleText1: LandingScreenConstants.trackYour, titleText2: LandingScreenConstants.cardDailyActivity, descriptionText: LandingScreenConstants.cardDescription)
        .environmentObject(ThemeManager())
}
