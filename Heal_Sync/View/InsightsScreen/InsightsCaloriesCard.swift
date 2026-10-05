//
//  InsightsCaloriesCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 28/09/26.
//

import SwiftUI

struct InsightsCaloriesCard: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var theme: ThemeManager

    private struct DayData { let day: String; let calories: Double }

    @State private var weekData: [DayData] = []
    @State private var selectedIndex = 6
    @State private var todayIndex = 6
    @State private var lastWeekTotal: Double = 0

    private let store = ActivityStore.shared
    private let calorieOrange = Color(red: 1.0, green: 0.62, blue: 0.18)
    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    private var calorieGoal: Int { ActivityViewModel.dayCalorieGoal }
    private var todayCalories: Double { max(Double(activityVM.todayCaloriesValue), weekData.indices.contains(todayIndex) ? weekData[todayIndex].calories : 0) }
    private var weekTotal: Double { weekData.reduce(0) { $0 + $1.calories } }
    private var dailyAvg: Double { weekTotal / 7.0 }
    private var progress: Double { calorieGoal > 0 ? min(max(todayCalories / Double(calorieGoal), 0), 1) : 0 }
    private var hasData: Bool { weekTotal > 0 || todayCalories > 0 }
    private var chartMax: Double { max(max(weekData.map(\.calories).max() ?? 0, todayCalories, Double(calorieGoal)) * 1.15, 100) }
    private var selectedCalories: Double { displayValue(at: selectedIndex) }

    private var changeText: String {
        guard lastWeekTotal > 0, weekTotal > 0 else { return "vs. last week" }
        let pct = Int((weekTotal - lastWeekTotal) / lastWeekTotal * 100)
        return "\(pct >= 0 ? "+" : "")\(pct)% vs. last week"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: ActivityScreenConstants.StatsImages.flame).font(.system(size: 18, weight: .bold)).foregroundColor(calorieOrange)
                Text(InsightsScreenConstants.caloriesTitle).font(.system(size: 17, weight: .semibold)).foregroundColor(theme.colors.primaryText)
                Spacer()
                Image(systemName: InsightsScreenConstants.Images.chevronRight).font(.system(size: 15, weight: .semibold)).foregroundColor(theme.colors.secondaryText)
            }

            // Value & Trend
            HStack(alignment: .bottom, spacing: 12) {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(Int(selectedCalories))").font(.system(size: 38, weight: .bold)).foregroundColor(theme.colors.primaryText)
                        .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                    Text(InsightsScreenConstants.kcalUnit).font(.system(size: 18)).foregroundColor(theme.colors.secondaryText).padding(.bottom, 4)
                }
                Spacer()
                HStack(spacing: 3) {
                    Image(systemName: InsightsScreenConstants.Images.trendUp).font(.system(size: 13, weight: .bold))
                    Text(changeText).font(.system(size: 14, weight: .bold))
                }.foregroundColor(mintGreen).padding(.bottom, 6)
            }

            // Progress Bar
            VStack(alignment: .leading, spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(theme.isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.10))
                        Capsule().fill(LinearGradient(colors: [calorieOrange, calorieOrange.opacity(0.75)], startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(0, geo.size.width * CGFloat(progress)))
                            .shadow(color: calorieOrange.opacity(0.6), radius: 6)
                    }
                }.frame(height: 8)
                Text("\(Int(progress * 100))% of \(calorieGoal.formatted()) \(InsightsScreenConstants.kcalUnit) \(InsightsScreenConstants.caloriesGoalLabel)")
                    .font(.system(size: 13)).foregroundColor(theme.colors.secondaryText)
            }

            if !hasData {
                Text(InsightsScreenConstants.caloriesEmptyState).font(.system(size: 13)).foregroundColor(theme.colors.secondaryText)
            }

            // Chart Section
            barChartView

            // Footer Badges
            HStack(spacing: 12) {
                statBadge(title: InsightsScreenConstants.thisWeekTitle, value: "\(Int(weekTotal)) \(InsightsScreenConstants.kcalUnit)", icon: "flame.fill", iconColor: calorieOrange)
                statBadge(title: InsightsScreenConstants.dailyAvgTitle, value: "\(Int(dailyAvg)) \(InsightsScreenConstants.kcalUnit)", icon: "chart.bar.fill", iconColor: .white.opacity(0.8))
            }
        }
        .padding(20)
        .background(theme.colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1))
        .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 16)
        .onAppear(perform: refresh)
        .onChange(of: activityVM.lastUpdated) { _, _ in refresh() }
    }

    // Bar Chart Subview
    private var barChartView: some View {
        let chartLevels = [chartMax, chartMax * 0.66, chartMax * 0.33, 0].map { "\(Int($0))" }
        return HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(chartLevels, id: \.self) { label in
                    Text(label).font(.system(size: 11, weight: .semibold)).foregroundColor(theme.colors.secondaryText).frame(height: 40)
                }
            }.padding(.top, 8)

            VStack(spacing: 6) {
                ZStack(alignment: .bottomLeading) {
                    VStack(spacing: 10) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle().fill(theme.isDarkMode ? Color.white.opacity(0.05) : Color.black.opacity(0.08)).frame(height: 1).frame(height: 30)
                        }
                    }.frame(height: 150).frame(maxWidth: .infinity, alignment: .leading)

                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(weekData.indices, id: \.self) { i in
                            let val = displayValue(at: i)
                            let isSelected = i == selectedIndex
                            let h = max(12, CGFloat(chartMax > 0 ? val / chartMax : 0) * 90)

                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(calorieOrange.opacity(isSelected ? 0.25 : 0.12))
                                    .frame(width: isSelected ? 27 : 12, height: h + (isSelected ? 18 : 10))
                                    .shadow(color: calorieOrange.opacity(isSelected ? 0.5 : 0.4), radius: isSelected ? 8 : 4)

                                RoundedRectangle(cornerRadius: 5)
                                    .fill(calorieOrange.opacity(isSelected ? 1.0 : 0.85))
                                    .frame(width: isSelected ? 12 : 13, height: h)
                                    .shadow(color: calorieOrange.opacity(isSelected ? 0.9 : 0.6), radius: isSelected ? 10 : 3)

                                if isSelected {
                                    Text("\(Int(val))")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(theme.isDarkMode ? .black : .white)
                                        .padding(.horizontal, 5).padding(.vertical, 2)
                                        .background(Capsule().fill(theme.isDarkMode ? .white : .black))
                                        .offset(y: -h - 15)
                                        .transition(.scale.combined(with: .opacity))
                                        .zIndex(1)
                                }
                            }
                            .frame(height: 110, alignment: .bottom).frame(maxWidth: .infinity).contentShape(Rectangle())
                            .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedIndex = i } }
                        }
                    }.frame(height: 110).padding(.bottom, 15)
                }.frame(height: 140).padding(.top, 26)

                HStack(spacing: 0) {
                    ForEach(weekData.indices, id: \.self) { i in
                        Text(weekData[i].day)
                            .font(.system(size: 11, weight: i == selectedIndex ? .semibold : .regular))
                            .foregroundColor(theme.colors.secondaryText.opacity(i == selectedIndex ? 1.0 : 0.8))
                            .frame(maxWidth: .infinity).contentShape(Rectangle())
                            .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedIndex = i } }
                    }
                }
            }
        }
    }

    private func statBadge(title: String, value: String, icon: String, iconColor: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 15, weight: .semibold)).foregroundColor(iconColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 13)).foregroundColor(theme.colors.secondaryText)
                Text(value).font(.system(size: 15, weight: .bold)).foregroundColor(theme.colors.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(theme.isDarkMode ? Color.white.opacity(0.06) : Color.black.opacity(0.05)))
    }

    private func displayValue(at index: Int) -> Double {
        guard weekData.indices.contains(index) else { return 0 }
        return index == todayIndex ? max(weekData[index].calories, Double(activityVM.todayCaloriesValue)) : weekData[index].calories
    }

    private func refresh() {
        var cal = Calendar.current
        cal.firstWeekday = 2
        let now = Date()
        let today = cal.startOfDay(for: now)

        guard let interval = cal.dateInterval(of: .weekOfYear, for: now) else { return }
        let monday = cal.startOfDay(for: interval.start)
        guard let sunday = cal.date(byAdding: .day, value: 6, to: monday) else { return }

        let days = store.dailyCalories(end: sunday, days: 7)
        let fmt = DateFormatter(); fmt.dateFormat = "E"

        todayIndex = max(0, min(6, cal.dateComponents([.day], from: monday, to: today).day ?? 6))
        selectedIndex = todayIndex

        weekData = (0..<7).map { i in
            let date = cal.date(byAdding: .day, value: i, to: monday) ?? monday
            let calories = i < days.count ? days[i].calories : 0
            return DayData(day: String(fmt.string(from: date).prefix(3)), calories: calories)
        }

        if let prevSun = cal.date(byAdding: .day, value: -1, to: monday),
           let prevMon = cal.date(byAdding: .day, value: -6, to: prevSun) {
            lastWeekTotal = store.sumCalories(from: prevMon, to: prevSun)
        } else {
            lastWeekTotal = 0
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color(red: 0.05, green: 0.02, blue: 0.06), Color(red: 0.06, green: 0.10, blue: 0.09)], startPoint: .leading, endPoint: .trailing).ignoresSafeArea()
        InsightsCaloriesCard().environmentObject(ActivityViewModel()).environmentObject(ThemeManager())
    }
}
