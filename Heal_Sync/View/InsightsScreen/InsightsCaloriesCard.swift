//
//  InsightsCaloriesCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import SwiftUI

struct InsightsCaloriesCard: View {
    @EnvironmentObject var activityVM: ActivityViewModel

    @State private var weekCalories: [Double] = Array(repeating: 0, count: 7)
    @State private var weekDayLabels: [String] = Array(repeating: "", count: 7)
    @State private var selectedIndex: Int = 6
    @State private var lastWeekTotal: Double = 0

    private let store = ActivityStore.shared
    private let calorieOrange = Color(red: 1.0, green: 0.62, blue: 0.18)
    private let darkTeal = Color(red: 0.07, green: 0.14, blue: 0.16)
    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    private var calorieGoal: Int { ActivityViewModel.dayCalorieGoal }

    private var todayCalories: Double {
        let live = Double(activityVM.todayCaloriesValue)
        let stored = weekCalories.last ?? 0
        return max(live, stored)
    }

    private var weekTotal: Double { weekCalories.reduce(0, +) }
    private var dailyAvg: Double { weekTotal / 7.0 }

    private var progress: Double {
        guard calorieGoal > 0 else { return 0 }
        return min(max(todayCalories / Double(calorieGoal), 0), 1)
    }

    private var hasData: Bool { weekTotal > 0 || todayCalories > 0 }

    private var chartMax: Double {
        let peak = max(weekCalories.max() ?? 0, todayCalories, Double(calorieGoal))
        return max(peak * 1.15, 100)
    }

    private var changeText: String {
        guard lastWeekTotal > 0, weekTotal > 0 else { return "vs. last week" }
        let pct = (weekTotal - lastWeekTotal) / lastWeekTotal * 100
        let sign = pct >= 0 ? "+" : ""
        return "\(sign)\(Int(pct))% vs. last week"
    }

    private var selectedCalories: Double { displayValue(at: selectedIndex) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerView
            valueRowView
            progressBarView

            if !hasData {
                Text(InsightsScreenConstants.caloriesEmptyState)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }

            // Bar Chart Area
            CaloriesBarChart(
                weekCalories: weekCalories,
                weekDayLabels: weekDayLabels,
                selectedIndex: $selectedIndex,
                chartMax: chartMax,
                calorieOrange: calorieOrange,
                displayValue: displayValue
            )

            statsFooterView
        }
        .padding(20)
        .background(darkTeal.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .onAppear(perform: refresh)
        .onChange(of: activityVM.lastUpdated) { _, _ in refresh() }
    }

    // Subviews

    private var headerView: some View {
        HStack(spacing: 8) {
            Image(systemName: ActivityScreenConstants.StatsImages.flame)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(calorieOrange)

            Text(InsightsScreenConstants.caloriesTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Image(systemName: InsightsScreenConstants.Images.chevronRight)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.6))
        }
    }

    private var valueRowView: some View {
        HStack(alignment: .bottom, spacing: 12) {
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("\(Int(selectedCalories))")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.white)
                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)

                Text(InsightsScreenConstants.kcalUnit)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.bottom, 4)
            }

            Spacer()

            HStack(spacing: 3) {
                Image(systemName: InsightsScreenConstants.Images.trendUp)
                    .font(.system(size: 13, weight: .bold))
                Text(changeText)
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundColor(mintGreen)
            .padding(.bottom, 6)
        }
    }

    private var progressBarView: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.12))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [calorieOrange, calorieOrange.opacity(0.75)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * CGFloat(progress)))
                        .shadow(color: calorieOrange.opacity(0.6), radius: 6)
                }
            }
            .frame(height: 8)

            Text("\(Int(progress * 100))% of \(calorieGoal.formatted()) \(InsightsScreenConstants.kcalUnit) \(InsightsScreenConstants.caloriesGoalLabel)")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
        }
    }

    private var statsFooterView: some View {
        HStack(spacing: 12) {
            statBadge(
                title: InsightsScreenConstants.thisWeekTitle,
                value: "\(Int(weekTotal)) \(InsightsScreenConstants.kcalUnit)",
                icon: "flame.fill",
                iconColor: calorieOrange
            )

            statBadge(
                title: InsightsScreenConstants.dailyAvgTitle,
                value: "\(Int(dailyAvg)) \(InsightsScreenConstants.kcalUnit)",
                icon: "chart.bar.fill",
                iconColor: .white.opacity(0.8)
            )
        }
    }

    private func statBadge(title: String, value: String, icon: String, iconColor: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                Text(value)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
        )
    }

    // Helpers & Data Loading

    private func displayValue(at index: Int) -> Double {
        guard weekCalories.indices.contains(index) else { return 0 }
        if index == weekCalories.count - 1 {
            return max(weekCalories[index], Double(activityVM.todayCaloriesValue))
        }
        return weekCalories[index]
    }

    private func refresh() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let days = store.dailyCalories(end: today, days: 7)
        var calories = days.map { $0.calories }

        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        var labels = days.map { String(formatter.string(from: $0.date).prefix(3)) }

        // Ensure 7 items count
        while calories.count < 7 {
            calories.insert(0, at: 0)
            labels.insert("", at: 0)
        }

        weekCalories = calories
        weekDayLabels = labels
        selectedIndex = 6

        // Previous week total for calculation
        if let prevEnd = calendar.date(byAdding: .day, value: -7, to: today),
           let prevStart = calendar.date(byAdding: .day, value: -13, to: today) {
            lastWeekTotal = store.sumCalories(from: prevStart, to: prevEnd)
        } else {
            lastWeekTotal = 0
        }
    }
}

// Extracted Bar Chart View

private struct CaloriesBarChart: View {
    let weekCalories: [Double]
    let weekDayLabels: [String]
    @Binding var selectedIndex: Int
    let chartMax: Double
    let calorieOrange: Color
    let displayValue: (Int) -> Double

    private var chartLevels: [String] {
        [chartMax, chartMax * 0.66, chartMax * 0.33, 0].map { "\(Int($0))" }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Y-Axis Labels
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(chartLevels, id: \.self) { label in
                    Text(label)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white.opacity(0.70))
                        .frame(height: 40)
                }
            }
            .padding(.top, 8)

            // Chart Bars & X-Axis
            VStack(spacing: 6) {
                ZStack(alignment: .bottomLeading) {
                    // Grid Lines
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
                        ForEach(weekCalories.indices, id: \.self) { index in
                            let value = displayValue(index)
                            let isSelected = index == selectedIndex
                            let barH = barHeight(for: value)

                            ZStack(alignment: .bottom) {
                                // Glow Beam
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(calorieOrange.opacity(isSelected ? 0.25 : 0.12))
                                    .frame(width: isSelected ? 27 : 12, height: barH + (isSelected ? 18 : 10))
                                    .shadow(color: calorieOrange.opacity(isSelected ? 0.5 : 0.4), radius: isSelected ? 8 : 4)

                                // Main Bar
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(calorieOrange.opacity(isSelected ? 1.0 : 0.85))
                                    .frame(width: isSelected ? 12 : 13, height: barH)
                                    .shadow(color: calorieOrange.opacity(isSelected ? 0.9 : 0.6), radius: isSelected ? 10 : 3)

                                // Tooltip
                                if isSelected {
                                    Text("\(Int(value))")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(Capsule().fill(.white))
                                        .offset(y: -barH - 15)
                                        .transition(.scale.combined(with: .opacity))
                                        .zIndex(1)
                                }
                            }
                            .frame(height: 110, alignment: .bottom)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                    .frame(height: 110)
                    .padding(.bottom, 15)
                }
                .frame(height: 140)
                .padding(.top, 26)

                // Day Labels
                HStack(spacing: 0) {
                    ForEach(weekDayLabels.indices, id: \.self) { index in
                        let isSelected = index == selectedIndex
                        Text(weekDayLabels[index])
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

    private func barHeight(for value: Double) -> CGFloat {
        let maxBarHeight: CGFloat = 90
        guard chartMax > 0 else { return 12 }
        return max(12, CGFloat(value / chartMax) * maxBarHeight)
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

        InsightsCaloriesCard()
            .environmentObject(ActivityViewModel())
    }
}
