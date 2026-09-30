//
//  InsightsSleepCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import SwiftUI

struct InsightsSleepCard: View {
    
    @Binding var selectedPeriod: SleepFilterPeriod
    
    var sleepData: SleepDataModel
    
    var body: some View{
        HStack(alignment: .top, spacing: 12){
            VStack(alignment: .leading, spacing: 14){
                Menu {
                    Picker(InsightsSleepCardConstants.pickerTitle, selection: $selectedPeriod){
                        ForEach(SleepFilterPeriod.allCases){ period in
                            Text(period.rawValue.capitalized).tag(period)
                        }
                    }
                } label: {
                    HStack(spacing: 4){
                        Text(selectedPeriod.rawValue)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(sleepData.score)")
                        .font(.system(size: 38, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.9, blue: 0.4))
                    
                    Text(InsightsSleepCardConstants.score)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                }
                
                Text(sleepData.sleepDuration)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color(red: 0.04, green: 0.08, blue: 0.09))
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 12) {
                // Insight Title Header
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                    
                    Text(InsightsSleepCardConstants.sleepInsights)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // Bullet Point Insights List
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(sleepData.insights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.gray)
                            
                            Text(insight)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color.white.opacity(0.85))
                                .lineSpacing(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var selectedPeriod: SleepFilterPeriod = .tonight

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            InsightsSleepCard(
                selectedPeriod: $selectedPeriod,
                sleepData: InsightsSleepCardConstants.mockData(for: selectedPeriod)
            )
        }
    }
}
