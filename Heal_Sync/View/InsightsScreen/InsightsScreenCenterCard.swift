//
//  InsightsScreenCenterCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct InsightsScreenCenterCard: View {

    // Week Data
    private let weekData: [(day: String, value: Double)] = [
        ("Mon", 62),
        ("Tue", 70),
        ("Wed", 64),
        ("Thu", 58),
        ("Fri", 72),
        ("Sat", 52),
        ("Sun", 60)
    ]
    private let maxValue: Double = 120
    @State private var selectedIndex: Int = 4

    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)
    private let darkTeal = Color(red: 0.07, green: 0.14, blue: 0.16)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
            HStack(spacing: 8) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(mintGreen)

                Text("Heart Rate")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }

            // Value row: selected day value + change vs last week
            HStack(alignment: .bottom, spacing: 120) {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(Int(weekData[selectedIndex].value))")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                    Text("bpm")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.bottom, 4)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 13, weight: .bold))
                        Text("2%")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(mintGreen)

                    Text("vs. last week")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 4)
            }

            // Bar chart with Y-axis grid lines
            HStack(alignment: .top, spacing: 8) {

                // Y-axis labels
                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(["120", "80", "40", "0"], id: \.self) { label in
                        Text(label)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.70))
                            .frame(height: 40)
                    }
                }
                .padding(.top, 8)

                // Right side: grid + bars + day labels
                VStack(spacing: 6) {
                    ZStack(alignment: .bottomLeading) {

                        // Horizontal grid lines
                        VStack(spacing: 10) {
                            ForEach(0..<4, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.white.opacity(0.05))
                                    .frame(height: 1)
                                    .frame(height: 30)
                            }
                        }
                        .frame(height: 150)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Bars
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(weekData.indices, id: \.self) { index in
                                let item = weekData[index]
                                let isSelected = index == selectedIndex
                                ZStack(alignment: .bottom) {
                                    // Tooltip bubble
                                    if isSelected {
                                        Text("\(Int(item.value))")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 5)
                                            .padding(.vertical, 2)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(.white)
                                            )
                                            .offset(y: -barHeight(for: item.value) - 8)
                                            .transition(.scale.combined(with: .opacity))
                                            .zIndex(1)
                                    }

                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(
                                            LinearGradient(
                                                colors: isSelected
                                                ? [mintGreen, mintGreen.opacity(0.7)]
                                                : [mintGreen.opacity(0.95), mintGreen.opacity(0.45)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: isSelected ? 14 : 12, height: barHeight(for: item.value))
                                        .opacity(isSelected ? 1.0 : 0.6)
                                }
                                .frame(height: 90, alignment: .bottom)
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedIndex = index
                                    }
                                }
                            }
                        }
                        .frame(height: 90)
                        .padding(.bottom, 15)
                    }
                    .frame(height: 120)
                    .padding(.top, 26)

                    // Day labels
                    HStack(spacing: 0) {
                        ForEach(weekData.indices, id: \.self) { index in
                            let isSelected = index == selectedIndex
                            Text(weekData[index].day)
                                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                                .foregroundColor(.white.opacity(isSelected ? 0.95 : 0.75))
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedIndex = index
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(darkTeal.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    private func barHeight(for value: Double) -> CGFloat {
        let maxBarHeight: CGFloat = 90
        return max(12, CGFloat(value / maxValue) * maxBarHeight)
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
        InsightsScreenCenterCard()
    }
}
