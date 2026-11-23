//
//  InsightsSleepCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import SwiftUI

struct InsightsSleepCard: View {

    @EnvironmentObject var theme: ThemeManager
    @Binding var selectedPeriod: SleepFilterPeriod

    var sleepData: SleepDataModel

    var body: some View{
        HStack(alignment: .center, spacing: 12){
            VStack(alignment: .leading, spacing: 15){
                Menu {
                    Picker(InsightsSleepCardConstants.pickerTitle, selection: $selectedPeriod){
                        ForEach(SleepFilterPeriod.allCases){ period in
                            Text(period.rawValue.capitalized).tag(period)
                        }
                    }
                } label: {
                    HStack(spacing: 6){
                        Text(selectedPeriod.rawValue)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.gray)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(sleepData.score)")
                        .font(.system(size: 45, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.9, blue: 0.4))

                    Text(InsightsSleepCardConstants.score)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(theme.colors.primaryText)
                }

                Text(sleepData.sleepDuration)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(theme.colors.primaryText)
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: 180, alignment: .leading)
            .background(theme.colors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
            )
            .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 12) {
                // Insight Title Header
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)

                    Text(InsightsSleepCardConstants.sleepInsights)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(theme.colors.primaryText)
                }

                // Bullet Point Insights List
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(sleepData.insights, id: \.self) { insight in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)

                            Text(insight)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(theme.colors.secondaryText)
                                .lineSpacing(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: 180, alignment: .leading)
            .background(theme.colors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
            )
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
            .environmentObject(ThemeManager())
        }
    }
}
