//
//  ActivityScreenView.swift
//  Heal_Sync
//

import SwiftUI

struct ActivityScreenView: View {

    // Shared tracker owned by MainTabView (single pedometer stream).
    @EnvironmentObject var viewModel: ActivityViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.02, blue: 0.06),
                    Color(red: 0.06, green: 0.10, blue: 0.09)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()

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
                    goalSteps: viewModel.targetGoal
                )

                VStack(spacing: 25) {
                    HStack(spacing: 40) {
                        ActivityScreenComponent(
                            ImageName: "mapSymbol",
                            titleText: viewModel.distanceKmFormatted,
                            unitText: ActivityScreenConstants.km
                        )
                        
                        ActivityScreenComponent(
                            ImageName: "flame",
                            isSystemImage: true,
                            titleText: viewModel.activeCaloriesFormatted,
                            unitText: ActivityScreenConstants.kcal,
                            ImageColor: .red
                        )
                        
                        ActivityScreenComponent(
                            ImageName: "stopwatch",
                            isSystemImage: true,
                            titleText: viewModel.activeMinutesFormatted,
                            unitText: ActivityScreenConstants.min
                        )
                    }

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
}
