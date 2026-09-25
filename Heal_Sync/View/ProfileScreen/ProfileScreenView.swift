//
//  ProfileScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI

struct ProfileScreenView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var currentUser: CurrentUserViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showLogoutConfirm = false
    @State private var showEditSheet = false
    @State private var draftName = ""

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
                    // Header title + edit button
                    HStack(alignment: .top, spacing: 0) {
                        HeaderView(title: ProfileScreenConstants.mainTitle, subTitle: ProfileScreenConstants.subtitle)

                        Button {
                            draftName = currentUser.name
                            showEditSheet = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                )
                                .shadow(color: Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.35), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 22)
                        .padding(.trailing, 16)
                    }

                    // User card
                    HStack(spacing: 14) {
                        Text(currentUser.initial)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [mintGreen, mintGreen.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser.displayName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)

                            Text(currentUser.email)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .lineLimit(1)

                            if !currentUser.memberSince.isEmpty {
                                Text(currentUser.memberSince)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(mintGreen)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)

                    // Present day banner
                    HStack(spacing: 10) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(mintGreen)

                        Text(profileViewModel.todayTitle)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        Text(ProfileScreenConstants.todayBadge)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(mintGreen)
                            )
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)

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
            editSheet
                .presentationDetents([.medium])
        }
        .onAppear {
            profileViewModel.refresh()
        }
        // Live: refresh profile stats whenever the shared tracker records new data.
        .onChange(of: activityViewModel.lastUpdated) { _, _ in
            profileViewModel.refresh()
        }
        .onChange(of: authViewModel.isAuthenticated) { _, newValue in
            print("🔄 ProfileScreenView observed isAuthenticated change: \(newValue)")
        }
    }

    // Edit profile sheet (same dark + mint theme)

    private var editSheet: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.02, blue: 0.1),
                    Color(red: 0.02, green: 0.15, blue: 0.17)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(ProfileScreenConstants.editProfile)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)

                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                        .frame(width: 24)

                    TextField("", text: $draftName, prompt: Text(ProfileScreenConstants.namePlaceholder).foregroundColor(.white.opacity(0.4)))
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.words)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.07, green: 0.14, blue: 0.16).opacity(0.85))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                Button {
                    currentUser.updateName(draftName)
                    showEditSheet = false
                } label: {
                    Text(ProfileScreenConstants.save)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.30, green: 0.92, blue: 0.65))
                        )
                }
                .padding(.horizontal, 20)

                Button(ProfileScreenConstants.cancel, role: .cancel) {
                    showEditSheet = false
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

                Spacer()
            }
        }
    }
}

struct LogoutButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .bold))

                Text(ProfileScreenConstants.logout)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileScreenView()
        .environmentObject(AuthViewModel())
        .environmentObject(ActivityViewModel())
        .environmentObject(CurrentUserViewModel())
}
