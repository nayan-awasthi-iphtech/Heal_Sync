//
//  HomeHeaderView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 22/09/26.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) { 
            HStack(spacing: 12) {
                ZStack {
                    Image(systemName: WelcomeScreenConstants.Images.heartFill)
                        .resizable()
                        .font(.title)
                        .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        .frame(width: 38, height: 34)
                    
                    Image(systemName: WelcomeScreenConstants.Images.ecgWaveform)
                        .resizable()
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(width: 38, height: 18)
                }
                
                Text(WelcomeScreenConstants.appName)
                    .fontWeight(.bold)
                    .font(.system(size: 30, design: .default))
                    .foregroundStyle(Color.white)
            }
            Spacer()
            
            ZStack{
                Circle()
                    .fill(.black.opacity(0.3))
                    .frame(width: 52, height: 52)
                
                Image(systemName: "bell")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 52, height: 52)
                .background(
                    Circle()
                        .fill(.black.opacity(0.3))
                )
                .clipShape(Circle())
                .padding(.horizontal, 2)
        }
    }
}

#Preview{
    
    ZStack{
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.02, blue: 0.06),
                Color(red: 0.06, green: 0.20, blue: 0.19)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
        
        HomeHeaderView()
    }
}
