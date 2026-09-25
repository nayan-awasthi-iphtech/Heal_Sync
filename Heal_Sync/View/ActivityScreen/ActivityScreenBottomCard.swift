//
//  ActivityScreenBottomCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ActivityScreenBottomCard: View {
    var distanceKm: String = "0.0"
    var activityDate: Date = Date()

    // Daypart from the hour of the day
    private var daypart: String {
        let hour = Calendar.current.component(.hour, from: activityDate)
        switch hour {
        case 5..<12:
            return ActivityScreenConstants.morning
        case 12..<17:
            return ActivityScreenConstants.afternoon
        case 17..<22:
            return ActivityScreenConstants.evening
        default:
            return ActivityScreenConstants.night
        }
    }

    private var timeString: String {
        activityDate.formatted(date: .omitted, time: .shortened)
    }

    var body: some View {
        HStack(spacing:15){
            Image(systemName: ActivityScreenConstants.runImage)
                .resizable()
                .scaledToFit()
                .fontWeight(.heavy)
                .frame(width: 50, height: 50)
                .foregroundStyle(Color(red: 0.20, green: 0.69, blue: 0.67))
            
            VStack(alignment: .leading){
                Text("\(daypart) \(ActivityScreenConstants.run)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("\(ActivityScreenConstants.today), \(timeString)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            HStack(spacing: 3){
                Text(distanceKm)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                Text(ActivityScreenConstants.kmeter)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Image(systemName: ActivityScreenConstants.chevronRightImage)
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
