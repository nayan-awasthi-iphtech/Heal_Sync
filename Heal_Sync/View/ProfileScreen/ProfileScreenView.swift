//
//  ProfileScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI
import PhotosUI
import CoreData

struct ProfileScreenView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var currentUser: CurrentUserViewModel
    @EnvironmentObject var theme: ThemeManager
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var sleepTracker = SleepTrackerManager(context: PersistenceController.shared.container.viewContext)

    @State private var showLogoutConfirm = false
    @State private var showEditSheet = false
    @State private var draftName = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var draftHeight = ""
    @State private var draftWeight = ""
    @State private var todayBPM: Double = 0
    @State private var yesterdaySleepHours: Double = 0
    @State private var yesterdayLabel: String = ProfileScreenConstants.notSet
    @State private var bestDayStepsText: String = ProfileScreenConstants.notSet
    @State private var bestDayLabel: String = ProfileScreenConstants.notSet
    @State private var activeDaysText: String = ProfileScreenConstants.notSet
    @State private var monthDistanceText: String = ProfileScreenConstants.notSet
    @State private var streakText: String = ProfileScreenConstants.notSet

    var body: some View {
        ZStack {
            // 2. Screen background color -> theme
            ThemedBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    ProfileHeaderView {
                        draftName = currentUser.name
                        draftHeight = currentUser.heightCm > 0 ? String(currentUser.heightCm) : ""
                        draftWeight = currentUser.weightKg > 0 ? String(currentUser.weightKg) : ""
                        showEditSheet = true
                    }

                    ProfileUserCard(photoItem: $photoItem, currentUser: currentUser)

                    ProfileDayBanner(todayTitle: profileViewModel.todayTitle)

                    // Range picker + stats
                    PickerView(
                        selection: $profileViewModel.selectedRange,
                        options: profileViewModel.ranges
                    )
                    .onChange(of: profileViewModel.selectedRange) { _, _ in
                        profileViewModel.refresh()
                    }

                    Text(profileViewModel.rangeSubtitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(theme.colors.primaryText)
                        .padding(.horizontal, 16)

                    VStack(spacing: 10) {
                        HStack(alignment: .top, spacing: 10) {
                            HomeScreenOverviewCard1(
                                imageName: "figure.run",
                                titleText: ProfileScreenConstants.steps,
                                descriptionText: profileViewModel.stepsFormatted,
                                goalText: profileViewModel.stepGoalText,
                                progress: profileViewModel.stepsProgress
                            )

                            HomeScreenOverviewCard1(
                                imageName: "flame.fill",
                                titleText: ProfileScreenConstants.calories,
                                descriptionText: profileViewModel.caloriesFormatted,
                                goalText: profileViewModel.calorieGoalText,
                                progress: profileViewModel.caloriesProgress,
                                progressColor: Color.orange,
                                imageColor: Color.red
                            )
                        }

                        HStack(alignment: .top, spacing: 10) {
                            HomeScreenOverviewCard2(
                                imageName: "map.fill",
                                titleText: ProfileScreenConstants.distance,
                                descriptionText: profileViewModel.distanceKmFormatted,
                                resultText: ProfileScreenConstants.totalBadge
                            )

                            HomeScreenOverviewCard2(
                                imageName: "stopwatch.fill",
                                titleText: ProfileScreenConstants.activeTime,
                                descriptionText: profileViewModel.activeMinutesFormatted,
                                resultText: ProfileScreenConstants.activeBadge
                            )
                        }
                    }
                    .padding(.horizontal, 16)

                    HStack(alignment: .top, spacing: 10) {
                        HomeScreenOverviewCard2(
                            imageName: "heart.fill",
                            titleText: ProfileScreenConstants.heartRate,
                            descriptionText: todayBPM > 0 ? "\(Int(todayBPM)) \(ProfileScreenConstants.bpmUnit)" : ProfileScreenConstants.notSet,
                            resultText: ProfileScreenConstants.todayBadge,
                            imageColor: Color.red
                        )

                        HomeScreenOverviewCard2(
                            imageName: "moon.stars.fill",
                            titleText: ProfileScreenConstants.sleep,
                            descriptionText: yesterdaySleepText,
                            resultText: yesterdayLabel,
                            imageColor: Color.purple
                        )
                    }
                    .padding(.horizontal, 16)

                    Text(ProfileScreenConstants.bodyMetricsTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(theme.colors.primaryText)
                        .padding(.horizontal, 16)

                    HStack(alignment: .top, spacing: 10) {
                        HomeScreenOverviewCard2(
                            imageName: "ruler.fill",
                            titleText: ProfileScreenConstants.height,
                            descriptionText: currentUser.heightFormatted,
                            resultText: ProfileScreenConstants.cmUnit
                        )

                        HomeScreenOverviewCard2(
                            imageName: "scalemass.fill",
                            titleText: ProfileScreenConstants.weight,
                            descriptionText: currentUser.weightFormatted,
                            resultText: ProfileScreenConstants.kgUnit
                        )
                    }
                    .padding(.horizontal, 16)

                    ProfileBMICard(currentUser: currentUser)

                    Text(ProfileScreenConstants.highlightsTitle)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(theme.colors.primaryText)
                        .padding(.horizontal, 16)

                    HStack(alignment: .top, spacing: 10) {
                        HomeScreenOverviewCard2(
                            imageName: "trophy.fill",
                            titleText: ProfileScreenConstants.bestDay,
                            descriptionText: bestDayStepsText,
                            resultText: bestDayLabel,
                            imageColor: Color.orange
                        )

                        HomeScreenOverviewCard2(
                            imageName: "calendar.badge.checkmark",
                            titleText: ProfileScreenConstants.activeDays,
                            descriptionText: activeDaysText,
                            resultText: ProfileScreenConstants.last7Days,
                            imageColor: Color.green
                        )
                    }
                    .padding(.horizontal, 16)

                    HStack(alignment: .top, spacing: 10) {
                        HomeScreenOverviewCard2(
                            imageName: "map.fill",
                            titleText: ProfileScreenConstants.monthDistance,
                            descriptionText: monthDistanceText,
                            resultText: ProfileScreenConstants.totalBadge
                        )

                        HomeScreenOverviewCard2(
                            imageName: "flame.fill",
                            titleText: ProfileScreenConstants.dayStreak,
                            descriptionText: streakText,
                            resultText: ProfileScreenConstants.activeBadge,
                            imageColor: Color.red
                        )
                    }
                    .padding(.horizontal, 16)

                    // Logout (with confirmation)
                    LogoutButton {
                        showLogoutConfirm = true
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
                .padding(.bottom, 20)
            }
        }
        .alert(
            ProfileScreenConstants.logoutTitle,
            isPresented: $showLogoutConfirm
        ) {
            Button(ProfileScreenConstants.logoutCancel, role: .cancel) { }
            Button(ProfileScreenConstants.logoutConfirm, role: .destructive) {
                authViewModel.logout()
            }
        } message: {
            Text(ProfileScreenConstants.logoutMessage)
        }
        .sheet(isPresented: $showEditSheet) {
            ProfileEditSheet(
                draftName: $draftName,
                draftHeight: $draftHeight,
                draftWeight: $draftWeight,
                currentUser: currentUser
            ) {
                showEditSheet = false
            }
            .presentationDetents([.medium])
        }
        .onAppear {
            profileViewModel.refresh()
            currentUser.refresh()
            refreshVitals()
            refreshHighlights()
        }
        .onChange(of: photoItem) { _, newItem in
            guard let newItem else { return }
            Task {
                guard let data = try? await newItem.loadTransferable(type: Data.self) else { return }
                if let ui = UIImage(data: data), let compressed = ui.jpegData(compressionQuality: 0.7) {
                    currentUser.updateProfileImage(compressed)
                } else {
                    currentUser.updateProfileImage(data)
                }
            }
        }
        // Live: refresh profile stats whenever the shared tracker records new data.
        .onChange(of: activityViewModel.lastUpdated) { _, _ in
            profileViewModel.refresh()
            refreshHighlights()
        }
        .onChange(of: sleepTracker.sleepVersion) { _, _ in
            refreshVitals()
            refreshHighlights()
        }
        .onChange(of: authViewModel.isAuthenticated) { _, newValue in
            print("🔄 ProfileScreenView observed isAuthenticated change: \(newValue)")
        }
    }

    private var yesterdaySleepText: String {
        guard yesterdaySleepHours > 0 else { return ProfileScreenConstants.notSet }
        let h = Int(yesterdaySleepHours)
        let m = Int((yesterdaySleepHours - Double(h)) * 60)
        return "\(h)h \(m)m"
    }

    private func refreshVitals() {
        let now = Date()
        let calendar = Calendar.current
        let startToday = calendar.startOfDay(for: now)
        todayBPM = HeartRateStore.shared.averageBPM(from: startToday, to: now)
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: startToday) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            yesterdayLabel = formatter.string(from: yesterday)
            let real = sleepTracker.dailyHours(end: yesterday, days: 1).first?.hours ?? 0
            if real > 0 {
                yesterdaySleepHours = real
            } else if sleepTracker.isTouchedNight(yesterday) {
                yesterdaySleepHours = 0
            } else {
                yesterdaySleepHours = sleepTracker.placeholderHours(for: yesterday)
            }
        }
    }

    private func refreshHighlights() {
        let calendar = Calendar.current
        let now = Date()
        let startToday = calendar.startOfDay(for: now)
        let store = ActivityStore.shared

        var bestSteps = 0
        var bestDate: Date?
        var activeCount = 0
        var totalDistance = 0.0
        var totalSteps30 = 0
        for offset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: startToday) else { continue }
            let record = store.loadDay(dayID: ActivityStore.dayID(for: date))
            let steps = record?.steps ?? 0
            if steps > 0 {
                activeCount += 1
                totalSteps30 += steps
                let dist = record?.distance ?? 0
                totalDistance += dist > 0 ? dist : Double(steps) * 0.75
            }
            if steps > bestSteps {
                bestSteps = steps
                bestDate = date
            }
        }
        if bestSteps > 0, let bestDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, MMM d"
            bestDayStepsText = "\(bestSteps.formatted()) \(ProfileScreenConstants.stepsUnit)"
            bestDayLabel = formatter.string(from: bestDate)
        } else {
            bestDayStepsText = ProfileScreenConstants.notSet
            bestDayLabel = ProfileScreenConstants.notSet
        }
        activeDaysText = activeCount > 0 ? "\(activeCount) \(activeCount == 1 ? ProfileScreenConstants.dayUnit : ProfileScreenConstants.daysUnit)" : ProfileScreenConstants.notSet
        monthDistanceText = totalDistance > 0 ? String(format: "%.1f km", totalDistance / 1000.0) : ProfileScreenConstants.notSet

        var streak = 0
        for offset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: startToday) else { break }
            let steps = store.loadDay(dayID: ActivityStore.dayID(for: date))?.steps ?? 0
            if offset == 0 && steps == 0 { continue }
            guard steps > 0 else { break }
            streak += 1
        }
        streakText = streak > 0 ? "\(streak) \(streak == 1 ? ProfileScreenConstants.dayUnit : ProfileScreenConstants.daysUnit)" : ProfileScreenConstants.notSet
    }

}

#Preview {
    ProfileScreenView()
        .environmentObject(AuthViewModel())
        .environmentObject(ActivityViewModel())
        .environmentObject(CurrentUserViewModel())
        .environmentObject(ThemeManager())
}
