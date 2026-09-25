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

    // Daypart from the hour of the day: Morning / Afternoon / Evening / Night
    private var daypart: String {
        let hour = Calendar.current.component(.hour, from: activityDate)
        switch hour {
        case 5..<12:
            return "Morning"
        case 12..<17:
            return "Afternoon"
        case 17..<22:
            return "Evening"
        default:
            return "Night"
        }
    }

    private var timeString: String {
        // e.g. "7:00 AM" — locale aware, matches old hardcoded format
        activityDate.formatted(date: .omitted, time: .shortened)
    }

    var body: some View {
        HStack(spacing:15){
            Image(systemName: "figure.run")
                .resizable()
                .scaledToFit()
                .fontWeight(.heavy)
                .frame(width: 50, height: 50)
                .foregroundStyle(Color(red: 0.20, green: 0.69, blue: 0.67))
            
            VStack(alignment: .leading){
                Text("\(daypart) Run")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Today, \(timeString)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            HStack(spacing: 3){
                Text(distanceKm)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
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
