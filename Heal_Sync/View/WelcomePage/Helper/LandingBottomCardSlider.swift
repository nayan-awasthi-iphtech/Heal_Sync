//
//  LandingBottomCardSlider.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 01/10/26.
//

import SwiftUI
import Combine

struct LandingBottomCardSlider: View {
    
    @EnvironmentObject var theme: ThemeManager
    @State private var currentCard: Int = 0
    @State private var totalCards = 3
    
    var body: some View {
        
        VStack(){
            TabView(selection: $currentCard){
                LandingBottomCardView(
                    rightImg: LandingScreenConstants.Images.runningImage,
                    leftSymbol: LandingScreenConstants.Images.heartFill,
                    titleText1: LandingScreenConstants.cardTrack,
                    titleText2: LandingScreenConstants.cardDailyActivity,
                    descriptionText: LandingScreenConstants.cardDescription
                )
                .tag(0)
                
                LandingBottomCardView(
                    rightImg: LandingScreenConstants.Images.sleepImage,
                    leftSymbol: LandingScreenConstants.Images.moonFill,
                    titleText1: LandingScreenConstants.cardMonitor,
                    titleText2: LandingScreenConstants.cardSleep,
                    descriptionText: LandingScreenConstants.cardSleepDescription
                )
                .tag(1)
                
                LandingBottomCardView(
                    rightImg: LandingScreenConstants.Images.heartRateImage,
                    leftSymbol: LandingScreenConstants.Images.ecgWaveform,
                    titleText1: LandingScreenConstants.cardCheck,
                    titleText2: LandingScreenConstants.cardHeartRate,
                    descriptionText: LandingScreenConstants.cardHeartRateDescription
                )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 250)
            
            // Current Page Indicating dots
            HStack(spacing: 8) {
                ForEach(0..<totalCards , id: \.self) { index in
                    Circle()
                        .fill(
                            index == currentCard ? Color(red: 0.30, green: 0.92, blue: 0.65) : theme.colors.secondaryText.opacity(0.35)
                        )
                        .frame(width: 10, height: 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 25)
        }
        .onReceive(
            Timer.publish(
                every: 2,
                on: .main,
                in: .common
            )
            .autoconnect()
        ) { _ in
            withAnimation(.easeInOut(duration: 0.8)){
                if currentCard < totalCards - 1 {
                    currentCard += 1
                } else {
                    currentCard = 0
                }
            }
        }
    }
}

#Preview {
    LandingBottomCardSlider()
        .environmentObject(ThemeManager())
}
