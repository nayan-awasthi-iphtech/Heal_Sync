//
//  ActvityScreenComponent.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ActivityScreenComponent: View {
    
    var ImageName: String
    var isSystemImage: Bool = false
    var titleText: String = ""
    var unitText: String = ""
    var ImageColor: Color = Color(red: 0.20, green: 0.69, blue: 0.67)
    
    var body: some View {
        VStack(spacing: 8){

            if isSystemImage {
                Image(systemName: ImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .font(.system(size: 20,weight: .bold))
                    .foregroundColor(ImageColor)
            } else {
                Image(ImageName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(red: 0.20, green: 0.69, blue: 0.67))
            }
            
            Text(titleText)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.white)
            
            Text(unitText)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
        }
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
        ActivityScreenComponent(ImageName: "mapSymbol" , titleText: "5.2", unitText: "km")
            .padding()
    }
}
