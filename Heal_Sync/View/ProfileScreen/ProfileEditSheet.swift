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
    var onDismiss: () -> Void

    var body: some View {
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
