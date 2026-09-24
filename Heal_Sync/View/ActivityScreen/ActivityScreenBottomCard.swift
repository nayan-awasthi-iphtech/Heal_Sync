//
//  ActivityScreenBottomCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ActivityScreenBottomCard: View {
    var body: some View {
        HStack(spacing:15){
            Image(systemName: "figure.run")
                .resizable()
                .scaledToFit()
                .fontWeight(.heavy)
                .frame(width: 50, height: 50)
                .foregroundStyle(Color(red: 0.20, green: 0.69, blue: 0.67))
            
            VStack{
                Text("Morning Run")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Today, 7:00 AM")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            HStack(spacing: 3){
                Text("3.2")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Text("km")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.02, green: 0.13, blue: 0.08)).opacity(0.4)
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
    }
}
