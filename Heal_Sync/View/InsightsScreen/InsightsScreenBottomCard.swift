//
//  InsightsScreenBottomCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct InsightsScreenBottomCard: View {
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.yellow)
                .padding(12)
                .background(
                    Capsule()
                        .fill(Color.yellow.opacity(0.2))
                        .blur(radius: 10)
                )
            
            VStack(alignment: .leading, spacing: 5){
                Text("Keep it up!")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(.white)
                
                Text("Your hear rate is in healthy range")
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 17)
                .fill(Color(red: 0.07, green: 0.14, blue: 0.16))
        )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.02, blue: 0.06),
                Color(red: 0.06, green: 0.10, blue: 0.09)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
        InsightsScreenBottomCard()
    }
}
