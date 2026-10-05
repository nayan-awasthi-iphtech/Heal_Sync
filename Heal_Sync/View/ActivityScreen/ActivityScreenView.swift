//
//  ActivityScreenView.swift
//  Heal_Sync
//

import SwiftUI

struct ActivityScreenView: View {

    // Shared tracker owned by MainTabView
    @EnvironmentObject var viewModel: ActivityViewModel
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ZStack(alignment: .topLeading) {
            ThemedBackground()

            ScrollView(showsIndicators: false) {
                HeaderView(title: ActivityScreenConstants.mainTitle, subTitle: ActivityScreenConstants.subtitle)

                PickerView(
                    selection: $viewModel.selectedTab,
                    options: viewModel.options
                )
                .onChange(of: viewModel.selectedTab) { _, newTab in
                    // Fetch steps for selected range when tab changes
                    viewModel.loadActivityData(for: newTab)
                }

                // Circular Progress Ring displaying live/calculated steps & dynamic goal
                StepProgressCard(
                    currentSteps: viewModel.currentSteps,
                    goalSteps: viewModel.targetGoal,
                    isTracking: viewModel.isTracking,
                    onToggleTracking: {
                        if viewModel.isTracking {
                            viewModel.stopTracking()
                        } else {
                            viewModel.startTracking()
                        }
                    }
                )
                if !viewModel.isPedometerAvailable {
                    Text("Step counting is not available on this device.")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                if let pedometerError = viewModel.pedometerError {
                    Text(pedometerError)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                if viewModel.isPermissionDenied {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .font(.system(size: 15, weight: .bold))
                    .padding(.top, 4)
                }
                VStack(spacing: 25) {
                    HStack(spacing: 50) {
                        ActivityScreenStatsComponent(
                            ImageName: ActivityScreenConstants.StatsImages.mapPointer,
                            titleText: viewModel.distanceKmFormatted,
                            unitText: ActivityScreenConstants.km
                        )

                        Rectangle()
                            .fill(theme.isDarkMode ? Color.white : Color.black.opacity(0.15))
                            .frame(width: 2, height: 80)

                        ActivityScreenStatsComponent(
                            ImageName: ActivityScreenConstants.StatsImages.flame,
                            isSystemImage: true,
                            titleText: viewModel.activeCaloriesFormatted,
                            unitText: ActivityScreenConstants.kcal,
                            ImageColor: .red
                        )

                        Rectangle()
                            .fill(theme.isDarkMode ? Color.white : Color.black.opacity(0.15))
                            .frame(width: 2, height: 80)

                        ActivityScreenStatsComponent(
                            ImageName: ActivityScreenConstants.StatsImages.watch,
                            isSystemImage: true,
                            titleText: viewModel.activeMinutesFormatted,
                            unitText: ActivityScreenConstants.min
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(theme.colors.cardBackground)
                            .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
                    )

                    ActivityScreenBottomCard(
                        distanceKm: viewModel.distanceKmFormatted,
                        activityDate: viewModel.lastUpdated
                    )
                }
            }
        }
    }
}

#Preview {
    ActivityScreenView()
        .environmentObject(ActivityViewModel())
        .environmentObject(ThemeManager())
}
