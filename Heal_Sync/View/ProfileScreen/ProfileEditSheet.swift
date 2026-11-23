//
//  ProfileEditSheet.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI

struct ProfileEditSheet: View {

    @Binding var draftName: String
    @Binding var draftHeight: String
    @Binding var draftWeight: String
    @ObservedObject var currentUser: CurrentUserViewModel
    @EnvironmentObject private var theme: ThemeManager
    var onDismiss: () -> Void
    @State private var nameError: String? = nil

    var body: some View {
        ZStack {
            
           ThemedBackground()

            VStack(spacing: 20) {
                Text(ProfileScreenConstants.editProfile)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(theme.colors.primaryText)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.fill")
                            .foregroundColor(theme.colors.accent)
                            .frame(width: 24)

                        TextField("", text: $draftName, prompt: Text(ProfileScreenConstants.namePlaceholder).foregroundColor(theme.isDarkMode ? .white.opacity(0.4): .black.opacity(0.4)))
                            .foregroundColor(theme.colors.primaryText)
                            .textInputAutocapitalization(.words)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(theme.colors.cardBackground).opacity(0.85)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(nameError == nil ? (theme.isDarkMode ? Color.white.opacity(0.08) : Color.blue.opacity(0.08)) : Color.red.opacity(0.6), lineWidth: 1)
                    )

                    if let nameError {
                        Text(nameError)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 20)
                .onChange(of: draftName) { _, newValue in
                    if nameError != nil {
                        nameError = currentUser.validateName(newValue)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "ruler.fill")
                                .foregroundColor(theme.colors.accent)
                                .frame(width: 24)
                            TextField("", text: $draftHeight, prompt: Text(ProfileScreenConstants.heightPlaceholder).foregroundColor(theme.isDarkMode ? .white.opacity(0.4) : .black.opacity(0.4)))
                                .foregroundColor(theme.colors.primaryText)
                                .keyboardType(.decimalPad)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.colors.cardBackground).opacity(0.85)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(theme.isDarkMode ? .white.opacity(0.08) : .black.opacity(0.08), lineWidth: 1)
                        )

                        HStack(spacing: 12) {
                            Image(systemName: "scalemass.fill")
                                .foregroundColor(theme.colors.accent)
                                .frame(width: 24)
                            TextField("", text: $draftWeight, prompt: Text(ProfileScreenConstants.weightPlaceholder).foregroundColor(theme.isDarkMode ? .white.opacity(0.4) : .black.opacity(0.4)))
                                .foregroundColor(theme.colors.primaryText)
                                .keyboardType(.decimalPad)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.colors.cardBackground.opacity(0.85))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(theme.isDarkMode ? .white.opacity(0.08) : .black.opacity(0.08), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 20)

                Button {
                    if let err = currentUser.validateName(draftName) {
                        nameError = err
                        return
                    }
                    nameError = nil
                    currentUser.updateName(draftName)
                    let hTrim = draftHeight.trimmingCharacters(in: .whitespacesAndNewlines)
                    let wTrim = draftWeight.trimmingCharacters(in: .whitespacesAndNewlines)
                    let h = hTrim.isEmpty ? currentUser.heightCm : (Double(hTrim) ?? currentUser.heightCm)
                    let w = wTrim.isEmpty ? currentUser.weightKg : (Double(wTrim) ?? currentUser.weightKg)
                    currentUser.updateBody(heightCm: h, weightKg: w)
                    onDismiss()
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
                    onDismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

                Spacer()
            }
        }
    }
}
