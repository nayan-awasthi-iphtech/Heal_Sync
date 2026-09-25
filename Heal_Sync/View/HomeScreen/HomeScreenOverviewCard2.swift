//
//  HomeScreenOverviewCard2.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct HomeScreenOverviewCard2: View {
    
    let imageName: String
    let titleText: String
    let descriptionText: String
    let resultText: String
    
    var imageColor: Color = Color(red: 0.30, green: 0.92, blue: 0.65)
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: imageName)
                .font(.system(size: 19))
                .foregroundColor(imageColor)
                .frame(width: 22, height: 22)
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(titleText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                Text(descriptionText)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.85))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(resultText)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(red: 0.20, green: 0.77, blue: 0.60))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.07, green: 0.24, blue: 0.18).opacity(0.85))
                    )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 108, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    HomeScreenOverviewCard2(
        imageName: "moon.stars.fill",
        titleText: "Sleep",
        descriptionText: "7 h 20 m",
        resultText: "Good"
    )
}
