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
            
            Image("HomePageImage")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .foregroundStyle(.white).opacity(0.5)
        }
    }
}

#Preview{
    HomeHeaderView()
}
