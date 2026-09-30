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
    @AppStorage("healsync_is_dark_mode") private var isDarkMode = true

    private let mintGreen = Color(red: 0.30, green: 0.92, blue: 0.65)

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.02, blue: 0.1),
                    Color(red: 0.02, green: 0.15, blue: 0.17)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    ProfileHeaderView(isDarkMode: $isDarkMode) {
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
                        .foregroundStyle(.white)
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
                        .foregroundStyle(.white)
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
        }
        .onChange(of: sleepTracker.sleepVersion) { _, _ in
            refreshVitals()
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

}

#Preview {
    ProfileScreenView()
        .environmentObject(AuthViewModel())
        .environmentObject(ActivityViewModel())
        .environmentObject(CurrentUserViewModel())
}


