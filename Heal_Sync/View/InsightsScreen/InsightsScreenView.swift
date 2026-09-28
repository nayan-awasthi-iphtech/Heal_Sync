import SwiftUI

struct InsightsScreenView: View {

    @StateObject private var heartRateManager = HeartRateManager()
    @EnvironmentObject var activityVM: ActivityViewModel

    @State private var showInstructionsPopup: Bool = false

    @State private var selectedTab: String = InsightsScreenConstants.health
    let options = [
        InsightsScreenConstants.health,
        InsightsScreenConstants.sleep,
        InsightsScreenConstants.calories
    ]

    var body: some View {

        ZStack{
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.07),
                    Color(red: 0.04, green: 0.10, blue: 0.07)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()

            ScrollView{
                VStack{

                    HeaderView(title: InsightsScreenConstants.mainTitle, subTitle: InsightsScreenConstants.subtitle)

                    PickerView(selection: $selectedTab, options: options)

                    if selectedTab == InsightsScreenConstants.calories {
                        InsightsCaloriesCard()
                            .padding(.top, 8)
                    } else if selectedTab == InsightsScreenConstants.health {
                        InsightsScreenCenterCard(liveBPM: heartRateManager.currentBPM)
                            .padding(.top, 8)
                    } else {
                        InsightsSleepCard()
                            .padding(.top, 8)
                    }

                    if selectedTab == InsightsScreenConstants.health {
                        Button(action: {
                            withAnimation { showInstructionsPopup = true }
                        }) {
                            HStack {
                                Image(systemName: "hand.point.up.fill")
                                Text("Start Pulse Scan")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.30, green: 0.92, blue: 0.65))
                            .cornerRadius(14)
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 8)
                        .disabled(heartRateManager.isMeasuring)
                        .opacity(heartRateManager.isMeasuring ? 0.5 : 1.0)
                    }

                    if selectedTab == InsightsScreenConstants.calories {
                        InsightsScreenBottomCard(
                            title: InsightsScreenConstants.caloriesKeepItUp,
                            message: calorieInsightMessage
                        )
                        .padding(.top, 10)
                    } else {
                        InsightsScreenBottomCard()
                            .padding(.top, 10)
                    }

                    Spacer()
                }
            }
        }
        .overlay(
            Group {
                if showInstructionsPopup {
                    InstructionPopupCard (
                        onStart: {
                            withAnimation { showInstructionsPopup = false }
                            heartRateManager.startMeasurement()
                        },
                        onCancel: {
                            withAnimation{ showInstructionsPopup = false }
                        }
                    )
                }
            }
        )
        .overlay(
            Group {
                if heartRateManager.isMeasuring {
                    ZStack {
                        Color.black.opacity(0.65)
                            .ignoresSafeArea()
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.15))
                                    .frame(width: 72, height: 72)
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(heartRateManager.currentBPM > 0 ? .red : Color(red: 0.30, green: 0.92, blue: 0.65))
                            }
                            Text(heartRateManager.currentBPM > 0 ? "\(heartRateManager.currentBPM) bpm" : "-- bpm")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text(heartRateManager.fingerDetected ? InsightsScreenConstants.scanningText : InsightsScreenConstants.placeFingerText)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 12)
                            ProgressView(value: heartRateManager.scanProgress)
                                .tint(Color(red: 0.30, green: 0.92, blue: 0.65))
                                .padding(.horizontal, 8)
                            #if targetEnvironment(simulator)
                            Button(action: {
                                heartRateManager.simulateFingerRemove()
                            }) {
                                Text("Simulate Finger Off")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color(red: 0.30, green: 0.92, blue: 0.65))
                                    .cornerRadius(10)
                            }
                            #endif
                            Button(action: {
                                heartRateManager.cancelMeasurement()
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(20)
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.10, green: 0.12, blue: 0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
            }
        )
        .alert(
            "Camera Access",
            isPresented: Binding(
                get: { heartRateManager.errorMessage != nil },
                set: { if !$0 { heartRateManager.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {
                heartRateManager.errorMessage = nil
            }
        } message: {
            Text(heartRateManager.errorMessage ?? "")
        }
        .onDisappear {
            heartRateManager.cancelMeasurement()
        }
    }

    private var calorieInsightMessage: String {
        let today = activityVM.todayCaloriesValue
        let goal = ActivityViewModel.dayCalorieGoal
        if today <= 0 {
            return "No calories burned yet today. Start tracking to see progress."
        } else if today >= goal {
            return "Goal reached — \(today) of \(goal) kcal burned today."
        } else {
            return "\(today) of \(goal) kcal — keep moving to hit your goal."
        }
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
        InsightsScreenView()
            .environmentObject(ActivityViewModel())
    }
}
