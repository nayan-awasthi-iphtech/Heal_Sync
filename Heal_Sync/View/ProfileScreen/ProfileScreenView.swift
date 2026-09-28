//
//  ProfileScreenView.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 24/09/26.
//

import SwiftUI
import PhotosUI

struct ProfileScreenView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var currentUser: CurrentUserViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showLogoutConfirm = false
    @State private var showEditSheet = false
    @State private var draftName = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var draftHeight = ""
    @State private var draftWeight = ""

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
                            draftHeight = currentUser.heightCm > 0 ? String(currentUser.heightCm) : ""
                            draftWeight = currentUser.weightKg > 0 ? String(currentUser.weightKg) : ""
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
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            ZStack(alignment: .bottomTrailing) {
                                Group {
                                    if let img = currentUser.profileUIImage {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                    } else {
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
                                    }
                                }
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 22, height: 22)
                                    .background(Circle().fill(mintGreen))
                                    .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 1))
                            }
                        }

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

                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 10) {
                            Image(systemName: "heart.text.square.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(mintGreen)

                            Text(ProfileScreenConstants.bmi)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Spacer()

                            Text(currentUser.bmiFormatted)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 8) {
                            Text(currentUser.bmiCategory)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(currentUser.bmiCategoryColor)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(currentUser.bmiCategoryColor.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(currentUser.bmiCategoryColor.opacity(0.4), lineWidth: 1)
                                        )
                                )

                            Text(ProfileScreenConstants.bmiHealthyRange)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.55))

                            Spacer()
                        }

                        GeometryReader { geo in
                            let clamped = min(max(currentUser.bmiValue > 0 ? currentUser.bmiValue : 16, 14), 34)
                            let progress = (clamped - 14) / 20.0
                            ZStack(alignment: .leading) {
                                HStack(spacing: 2) {
                                    Rectangle().fill(Color.blue.opacity(0.7))
                                    Rectangle().fill(Color(red: 0.30, green: 0.92, blue: 0.65).opacity(0.85))
                                    Rectangle().fill(Color.orange.opacity(0.85))
                                    Rectangle().fill(Color.red.opacity(0.85))
                                }
                                .frame(height: 8)
                                .clipShape(Capsule())
                                .opacity(currentUser.bmiValue > 0 ? 1.0 : 0.25)

                                Circle()
                                    .fill(.white)
                                    .frame(width: 14, height: 14)
                                    .overlay(Circle().stroke(currentUser.bmiCategoryColor, lineWidth: 3))
                                    .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 1)
                                    .offset(x: max(0, min(progress * (geo.size.width - 14), geo.size.width - 14)))
                                    .opacity(currentUser.bmiValue > 0 ? 1.0 : 0.0)
                            }
                        }
                        .frame(height: 14)
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
            currentUser.refresh()
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

                HStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "ruler.fill")
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            .frame(width: 24)
                        TextField("", text: $draftHeight, prompt: Text(ProfileScreenConstants.heightPlaceholder).foregroundColor(.white.opacity(0.4)))
                            .foregroundColor(.white)
                            .keyboardType(.decimalPad)
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

                    HStack(spacing: 12) {
                        Image(systemName: "scalemass.fill")
                            .foregroundColor(Color(red: 0.30, green: 0.92, blue: 0.65))
                            .frame(width: 24)
                        TextField("", text: $draftWeight, prompt: Text(ProfileScreenConstants.weightPlaceholder).foregroundColor(.white.opacity(0.4)))
                            .foregroundColor(.white)
                            .keyboardType(.decimalPad)
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
                }
                .padding(.horizontal, 20)

                Button {
                    currentUser.updateName(draftName)
                    let h = Double(draftHeight) ?? currentUser.heightCm
                    let w = Double(draftWeight) ?? currentUser.weightKg
                    currentUser.updateBody(heightCm: h, weightKg: w)
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
