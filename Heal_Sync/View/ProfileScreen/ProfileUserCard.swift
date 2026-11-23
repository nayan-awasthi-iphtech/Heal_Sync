//
//  ProfileUserCard.swift
//  Heal_Sync
//
//  Created by iPHTech 30 on 29/09/26.
//

import SwiftUI
import PhotosUI

struct ProfileUserCard: View {

    @EnvironmentObject var theme: ThemeManager
    @Binding var photoItem: PhotosPickerItem?
    @ObservedObject var currentUser: CurrentUserViewModel

    private var mintGreen: Color { theme.colors.accent }

    var body: some View {
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
                    .foregroundColor(theme.colors.primaryText)
                    .lineLimit(1)

                Text(currentUser.email)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.colors.secondaryText)
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
                .fill(theme.colors.cardBackground)
                .shadow(color: theme.isDarkMode ? .clear : .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
