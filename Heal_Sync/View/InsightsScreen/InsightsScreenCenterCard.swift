//
//  InsightsScreenCenterCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct InsightsScreenCenterCard: View {
    @EnvironmentObject var theme: ThemeManager
    var liveBPM: Int = 0
    var isMeasuring: Bool = false

    private struct DayData { let day: String; let value: Double; let isDummy, isFuture: Bool }

    @State private var weekData: [DayData] = []
    @State private var lastWeekAvg: Double = 0
    @State private var selectedIndex: Int = 6

    private let store = HeartRateStore.shared
    private let dummyBPM: [Double] = [72, 76, 69, 74, 71, 78, 0]
    private let maxValue: Double = 120
    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    private var hasData: Bool { liveBPM > 0 || weekData.contains { $0.value > 0 && !$0.isDummy } }

    private var changeText: String {
        let real = weekData.compactMap { !$0.isDummy && $0.value > 0 ? $0.value : nil }
        guard !real.isEmpty, lastWeekAvg > 0 else { return InsightsScreenConstants.changePercent }
        let avg = real.reduce(0, +) / Double(real.count)
        let pct = Int((avg - lastWeekAvg) / lastWeekAvg * 100)
        return "\(pct >= 0 ? "+" : "")\(pct)%"
    }

    private var selectedHeaderText: String {
        if liveBPM > 0 { return "\(liveBPM)" }
        guard weekData.indices.contains(selectedIndex) else { return "—" }
        let item = weekData[selectedIndex]
        return (!item.isDummy && item.value <= 0) ? "—" : "\(Int(item.value))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: InsightsScreenConstants.Images.heartFill)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(liveBPM > 0 ? .red : mintGreen)
                    .animation(.easeInOut(duration: 0.5).repeatCount(liveBPM > 0 ? .max : 0), value: liveBPM)

                Text(InsightsScreenConstants.heartRate)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(theme.colors.primaryText)

                Spacer()

                Image(systemName: InsightsScreenConstants.Images.chevronRight)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(theme.colors.secondaryText)
            }

            // Value & Trend Row
            HStack(alignment: .bottom, spacing: 120) {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(selectedHeaderText)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(liveBPM > 0 ? mintGreen : theme.colors.primaryText)
                        .animation(.easeInOut(duration: 0.2), value: selectedIndex)

                    Text(InsightsScreenConstants.bpmUnit)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(theme.colors.secondaryText)
                        .padding(.bottom, 4)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 3) {
                        Image(systemName: InsightsScreenConstants.Images.trendUp).font(.system(size: 13, weight: .bold))
                        Text(changeText).font(.system(size: 15, weight: .bold))
                    }.foregroundColor(mintGreen)

                    Text(InsightsScreenConstants.vsLastWeek)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(theme.colors.primaryText)
                }.padding(.bottom, 4)
            }

            if !hasData {
                Text(InsightsScreenConstants.heartEmptyState)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(theme.colors.secondaryText)
            }

            // Chart Section
            barChartView
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 20).fill(theme.colors.cardBackground).shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1))
        .padding(.horizontal, 16)
        .onAppear { refresh() }
        .onChange(of: isMeasuring) { old, new in
            if old && !new { refresh(preserveSelection: false) }
        }
    }

    // Chart Subview
    private var barChartView: some View {
        HStack(alignment: .top, spacing: 8) {
            // Y-Axis Labels
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(InsightsScreenConstants.chartLevels, id: \.self) { label in
                    Text(label).font(.system(size: 12, weight: .semibold)).foregroundColor(theme.colors.secondaryText).frame(height: 40)
                }
            }.padding(.top, 8)

            // Grid & Bars
            VStack(spacing: 6) {
                ZStack(alignment: .bottomLeading) {
                    VStack(spacing: 10) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle().fill(theme.isDarkMode ? Color.white.opacity(0.05) : Color.black.opacity(0.08)).frame(height: 1).frame(height: 30)
                        }
                    }.frame(height: 150).frame(maxWidth: .infinity, alignment: .leading)

                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(weekData.indices, id: \.self) { i in
                            let item = weekData[i]
                            let isSel = i == selectedIndex
                            let isEmpty = !item.isDummy && item.value <= 0
                            let isInactive = item.isDummy || isEmpty
                            let base: Color = theme.isDarkMode ? .white : .gray

                            let beamColors = isInactive
                                ? [base.opacity(isSel ? 0.18 : 0.10), base.opacity(0.10)]
                                : [mintGreen.opacity(isSel ? 0.25 : 0.12), mintGreen.opacity(isSel ? 0.28 : 0.12)]

                            let barColors = isInactive
                                ? [base.opacity(0.35), base.opacity(0.25)]
                                : [mintGreen.opacity(isSel ? 1.0 : 0.95), mintGreen.opacity(0.95)]

                            let barH = isEmpty ? 4 : max(12, CGFloat(item.value / maxValue) * 90)

                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(LinearGradient(colors: beamColors, startPoint: .top, endPoint: .bottom))
                                    .frame(width: isSel ? 27 : 12, height: 70)
                                    .shadow(color: (isInactive ? base : mintGreen).opacity(0.5), radius: isSel ? 8 : 4)

                                RoundedRectangle(cornerRadius: 5)
                                    .fill(LinearGradient(colors: barColors, startPoint: .top, endPoint: .bottom))
                                    .frame(width: isSel ? 12 : 13, height: barH)
                                    .opacity(isInactive ? 0.45 : 1.0)
                                    .shadow(color: (isInactive ? base : mintGreen).opacity(0.95), radius: isSel ? 10 : 3)

                                if isSel {
                                    Text(isEmpty ? "—" : "\(Int(item.value))")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(theme.isDarkMode ? .black : .white)
                                        .padding(.horizontal, 5).padding(.vertical, 2)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(theme.isDarkMode ? Color.white : Color.black))
                                        .offset(y: -barH - 15)
                                        .transition(.scale.combined(with: .opacity))
                                        .zIndex(1)
                                }
                            }
                            .frame(height: 90, alignment: .bottom).frame(maxWidth: .infinity).contentShape(Rectangle())
                            .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedIndex = i } }
                        }
                    }.frame(height: 90).padding(.bottom, 15)
                }.frame(height: 120).padding(.top, 26)

                // Day Labels
                HStack(spacing: 0) {
                    ForEach(weekData.indices, id: \.self) { i in
                        let item = weekData[i]
                        Text(item.day)
                            .font(.system(size: 11, weight: i == selectedIndex ? .semibold : .regular))
                            .foregroundColor(theme.colors.secondaryText.opacity(item.isFuture ? 0.4 : (i == selectedIndex ? 1.0 : 0.8)))
                            .frame(maxWidth: .infinity).contentShape(Rectangle())
                            .onTapGesture { withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedIndex = i } }
                    }
                }
            }
        }
    }

    private func refresh(preserveSelection: Bool = false) {
        var cal = Calendar.current
        cal.firstWeekday = 2
        let now = Date(), today = cal.startOfDay(for: now)

        guard let interval = cal.dateInterval(of: .weekOfYear, for: now) else { return }
        let monday = cal.startOfDay(for: interval.start)

        let weekDates = (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: monday) }.map { cal.startOfDay(for: $0) }
        guard weekDates.count == 7 else { return }

        let realBPM = weekDates.map { store.averageBPM(from: $0, to: $0) }
        let fmt = DateFormatter(); fmt.dateFormat = "E"
        let todayIndex = max(0, min(6, cal.dateComponents([.day], from: monday, to: today).day ?? 6))

        weekData = (0..<7).map { i in
            let label = String(fmt.string(from: weekDates[i]).prefix(3))
            var val = realBPM[i]
            var isDummy = false
            if i < todayIndex && val <= 0 {
                val = dummyBPM[i % dummyBPM.count]
                isDummy = val > 0
            }
            return DayData(day: label, value: val, isDummy: isDummy, isFuture: i > todayIndex)
        }

        if !preserveSelection || selectedIndex >= weekData.count { selectedIndex = todayIndex }

        if let prevSun = cal.date(byAdding: .day, value: -1, to: monday) {
            let vals = store.dailyAverageBPM(end: prevSun, days: 7).map(\.bpm).filter { $0 > 0 }
            lastWeekAvg = vals.isEmpty ? 0 : vals.reduce(0, +) / Double(vals.count)
        } else { lastWeekAvg = 0 }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color(red: 0.05, green: 0.02, blue: 0.06), Color(red: 0.06, green: 0.10, blue: 0.09)], startPoint: .leading, endPoint: .trailing).ignoresSafeArea()
        InsightsScreenCenterCard().environmentObject(ThemeManager())
    }
}
