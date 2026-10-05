//
//  WeeklySleepChartView.swift
//  Heal_Sync
//

import SwiftUI
import Charts

struct WeeklySleepChartView: View {
    @EnvironmentObject var theme: ThemeManager
    @ObservedObject var manager: SleepTrackerManager

    // Local Chart State
    @State private var chartBars: [SleepBarData] = []
    @State private var showEditSheet = false
    @State private var editNight: Date = Date()
    @State private var editHours: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Header Stats
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(WeeklySleepChartConstants.weekTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)

                    Text("\(formattedTotalWeeklyHours) \(WeeklySleepChartConstants.hrsUnit)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(theme.colors.primaryText)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    // Edit button — top right, edit later instead of a save-time sheet
                    Button(action: {
                        let today = Calendar.current.startOfDay(for: Date())
                        editNight = today
                        editHours = chartBars.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })?.hours ?? 0
                        showEditSheet = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color(red: 0.30, green: 0.92, blue: 0.65)))
                    }

                    // Status Badge
                    if case .tracking = manager.currentState {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text(WeeklySleepChartConstants.liveTracking)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(12)
                    }
                }
            }

            // Swift Chart View
            Chart(chartBars) { bar in
                BarMark(
                    x: .value(WeeklySleepChartConstants.day, bar.dayLabel),
                    y: .value(WeeklySleepChartConstants.hrs, bar.hours)
                )
                .cornerRadius(6)
                .foregroundStyle(barColor(for: bar))
                // Dimmed look for placeholders so QA never reads them as real data
                .opacity(bar.isDummy ? 0.45 : 1.0)
            }
            .chartYScale(domain: 0...16)
            .chartYAxis {
                AxisMarks(position: .leading, values: [0, 4, 8, 12, 16]) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundStyle(theme.isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.12))
                    AxisValueLabel() {
                        if let intVal = value.as(Int.self) {
                            Text("\(intVal)h")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel() {
                        if let dayStr = value.as(String.self) {
                            Text(dayStr)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .frame(height: 180)
        }
        .padding(16)
//        .frame(width: 365, alignment: .center)
        .background(theme.colors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .onAppear {
            refreshChartData()
        }
        .onChange(of: manager.currentState) { _, _ in
            refreshChartData()
        }
        .onChange(of: manager.sleepVersion) { _, _ in
            refreshChartData()
        }
        .sheet(isPresented: $showEditSheet) {
            VStack(spacing: 16) {
                Text(WeeklySleepChartConstants.sleepTitle)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.colors.primaryText)
                    .padding(.top, 8)
                Picker(WeeklySleepChartConstants.pickerTitle, selection: $editNight) {
                    ForEach(chartBars) { bar in
                        Text(bar.dayLabel)
                            .tag(Calendar.current.startOfDay(for: bar.date))
                            .disabled(Calendar.current.startOfDay(for: bar.date) > Calendar.current.startOfDay(for: Date()))
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: editNight) { _, newNight in
                    editHours = chartBars.first(where: { Calendar.current.startOfDay(for: $0.date) == newNight })?.hours ?? 0
                }
                HStack(spacing: 12) {
                    Button("-") { editHours = max(0, ((editHours - 0.5) * 10).rounded() / 10) }
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color(red: 0.30, green: 0.92, blue: 0.65)))
                    Text(String(format: "%.1f h", editHours))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(theme.colors.primaryText)
                        .frame(minWidth: 120)
                    Button("+") { editHours = min(16, ((editHours + 0.5) * 10).rounded() / 10) }
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color(red: 0.30, green: 0.92, blue: 0.65)))
                }
                Button(WeeklySleepChartConstants.save) {
                    manager.saveNight(editNight, hours: editHours)
                    showEditSheet = false
                }
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Capsule().fill(Color(red: 0.30, green: 0.92, blue: 0.65)))
                Button(WeeklySleepChartConstants.clear, role: .destructive) {
                    manager.clearNight(editNight)
                    showEditSheet = false
                }
                Button(WeeklySleepChartConstants.cancel, role: .cancel) { showEditSheet = false }
                    .foregroundColor(theme.colors.secondaryText)
                Spacer()
            }
            .padding(20)
            .presentationDetents([.medium])
        }
    }

    // Bar styling

    private func barColor(for bar: SleepBarData) -> Color {
        if bar.isDummy {
            return theme.isDarkMode ? Color.white.opacity(0.25) : Color.gray.opacity(0.35)
        }
        if bar.isToday {
            return bar.isLive ? Color.green : Color(red: 0.30, green: 0.92, blue: 0.65)
        }
        return theme.isDarkMode ? Color.white.opacity(0.25) : Color.gray.opacity(0.35)
    }

    // Pipeline Calculation
    private func refreshChartData() {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let now = Date()

        // Find Monday of the current week
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now) else { return }
        let monday = weekInterval.start

        // Retrieve real values fetched from manager
        let fetchedDaily = manager.dailyHours(end: now, days: 7)
        let realHoursMap: [Date: Double] = Dictionary(uniqueKeysWithValues: fetchedDaily.map { ($0.date, $0.hours) })

        var updatedBars: [SleepBarData] = []
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = WeeklySleepChartConstants.format

        let todayStart = calendar.startOfDay(for: now)

        for dayIndex in 0..<7 {
            guard let dayDate = calendar.date(byAdding: .day, value: dayIndex, to: monday) else { continue }

            let isToday = calendar.isDate(dayDate, inSameDayAs: now)
            let dayLabel = dayFormatter.string(from: dayDate)
            let nightKey = calendar.startOfDay(for: dayDate)

            var hours: Double = 0.0
            var isLive: Bool = false
            var isDummy: Bool = false

            if isToday {
                // Today's calculation logic — always real, never dummy
                switch manager.currentState {
                case .tracking(_, let elapsedTime):
                    hours = (elapsedTime / 3600.0 * 10).rounded() / 10
                    isLive = true
                default:
                    hours = realHoursMap[nightKey] ?? 0.0
                }
            } else if nightKey < todayStart {
                let realPastHours = realHoursMap[nightKey] ?? 0.0
                if realPastHours > 0 {
                    hours = realPastHours
                } else if manager.isTouchedNight(nightKey) {
                    hours = 0.0
                } else {
                    hours = manager.placeholderHours(for: nightKey)
                    isDummy = true
                }
            } else {
                // Future days (later this week) — always 0, never dummy
                hours = 0.0
            }

            updatedBars.append(
                SleepBarData(
                    dayLabel: dayLabel,
                    date: dayDate,
                    hours: hours,
                    isToday: isToday,
                    isLive: isLive,
                    isDummy: isDummy
                )
            )
        }
        self.chartBars = updatedBars
    }

    /// Combined total — mock placeholders + dynamic real data.
    private var formattedTotalWeeklyHours: String {
        let total = chartBars.reduce(0.0) { $0 + $1.hours }
        return String(format: "%.1f", total)
    }
}
