//
//  Header.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 21/09/26.
//

import SwiftUI

struct WelcomeHeaderView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            
            HStack(spacing: 12) {
                ZStack {
                    Image(systemName: WelcomePageConstants.Images.heartFill)
                        .resizable()
                        .font(.title)
                        .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        .frame(width: 38, height: 34)
                    
                    Image(systemName: WelcomePageConstants.Images.ecgWaveform)
                        .resizable()
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(width: 38, height: 18)
                }
                
                Text(WelcomePageConstants.appName)
                    .fontWeight(.bold)
                    .font(.system(size: 30, design: .default))
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
            
            Image(systemName: WelcomePageConstants.Images.menuIcon)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    WelcomeHeaderView()
}
