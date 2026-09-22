//
//  WelcomeCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 21/09/26.
//

import SwiftUI

struct WelcomeCard: View {
    
    let imageName: String
    let titleText: String
    let descriptionText: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12){
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient (
                            colors: [
                                Color(red: 0.12, green: 0.28, blue: 0.24),
                                Color(red: 0.05, green: 0.18, blue: 0.16)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width:60 , height: 68)
                
                Image(systemName: imageName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text(titleText)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Text(descriptionText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.white.opacity(0.7))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
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
    WelcomeCard(
        imageName: "chart.bar.fill",
        titleText: WelcomePageConstants.Card1.title,
        descriptionText: WelcomePageConstants.Card1.des
    )
}
