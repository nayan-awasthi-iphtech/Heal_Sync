//
//  InsightsScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct InsightsScreenView: View {
    
    @State private var selectedTab: String = "Health"
    let options = ["Health", "Sleep", "Calories"]
    
    var body: some View {
        
        ZStack{
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.07),
                    Color(red: 0.04, green: 0.10, blue: 0.07)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            VStack{
                
                HeaderView(title: "Insights", subTitle: "Understand Today, Build a better tomorrow")
                
                PickerView(selection: $selectedTab, options: options)

                InsightsScreenCenterCard()
                    .padding(.top, 8)
                
                InsightsScreenBottomCard()
                    .padding(.top, 10)
                
                Spacer()
            }
        }
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
        InsightsScreenView()
    }
}
