//
//  HomeScreenOverviewCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct HomeScreenOverviewCard1: View {
    
    let imageName: String
    let titleText: String
    let descriptionText: String
    
    // Reusability parameters
    var goalText: String? = nil
    var progress: Double? = nil
    var progressColor: Color = Color(red: 0.30, green: 0.92, blue: 0.65)
    var imageColor: Color = Color(red: 0.30, green: 0.92, blue: 0.65)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 10) {
                
                Image(systemName: imageName)
                    .font(.system(size: 20))
                    .foregroundColor(imageColor)
                    .frame(width: 24, height: 24)
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 2) {
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
                    
                    if let goalText = goalText {
                        Text(goalText)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color.white.opacity(0.6))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Progress bar fills available card width
            if let progress = progress {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                        
                        Capsule()
                            .fill(progressColor)
                            .frame(width: max(0, geometry.size.width * CGFloat(min(max(progress, 0.0), 1.0))))
                    }
                }
                .frame(height: 6)
            } else {
                // Keeps equal height with Card2 when no progress
                Spacer()
                    .frame(height: 6)
            }
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
        HomeScreenOverviewCard1(
            imageName: "chart.bar.fill",
            titleText: "Steps",
            descriptionText: "7,895",
            goalText: "/10,000",
            progress: 0.78
        )
}
